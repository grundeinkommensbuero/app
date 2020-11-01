package rest

import database.benutzer.BenutzerDao
import database.benutzer.Credentials
import org.jboss.logging.Logger
import shared.Security
import java.lang.Exception
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.transaction.Transactional
import javax.ws.rs.*
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response

@Path("benutzer")
open class BenutzerRestResource {

    @EJB
    private lateinit var dao: BenutzerDao

    @EJB
    private lateinit var security: Security

    private val LOG = Logger.getLogger(this::class.java)

    @POST
    @Path("neu")
    @RolesAllowed("app")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Transactional
    open fun legeNeuenBenutzerAn(login: Login): Response {
        val benutzer = login.user
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        if (login.firebaseKey.isNullOrEmpty()) login.firebaseKey = "no-key"

        // Zum Vermeiden optisch ähnlicher Namen
        login.user.name = login.user.name?.trim()

        if (benutzer.name != null && dao.benutzernameExistiert(benutzer.name!!)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername ist bereits vergeben"))
                    .build()
        }

        try {
            val benutzerAusDb = dao.legeNeuenBenutzerAn(benutzer.convertToBenutzer())

            val hashMitSalt = security.hashSecret(login.secret!!)
            dao.legeNeueCredentialsAn(Credentials(
                    benutzerAusDb.id,
                    hashMitSalt.hash,
                    hashMitSalt.salt,
                    login.firebaseKey!!,
                    listOf("app", "user")))

            return Response.ok().entity(benutzerAusDb).build()
        } catch (e: Exception) {
            LOG.error("Fehler beim Anlegen eines Benutzers: $benutzer", e)
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        }
    }

    @POST
    @Path("authentifiziere")
    @RolesAllowed("app")
    @Produces(APPLICATION_JSON)
    open fun authentifiziereBenutzer(login: Login): Response {
        val benutzer = login.user
        if (benutzer.id == null) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID darf nicht leer sein"))
                    .build()
        }
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        val credentials: Credentials?
        try {
            credentials = dao.getCredentials(benutzer.id!!)
        } catch (e: java.lang.IllegalArgumentException) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID ist ungültig"))
                    .build()
        }
        if (credentials == null) {
            LOG.info("Login mit unbekanntem Benutzer ${login.user.id}")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        }
        LOG.warn(credentials.roles)
        val verifiziert: Boolean?
        try {
            verifiziert = security.verifiziereSecretMitHash(login.secret!!, Security.HashMitSalt(credentials.secret, credentials.salt))
        } catch (e: Exception) {
            val meldung = "Technischer Fehler beim Verifizieren: ${e.localizedMessage}"
            LOG.info(meldung)
            return Response.status(500).entity(RestFehlermeldung(meldung)).build()
        }

        if (!verifiziert) {
            LOG.info("Falscher Login mit Benutzer ${login.user.id}")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        }
        return Response
                .ok()
                .entity(true)
                .build()
    }
}