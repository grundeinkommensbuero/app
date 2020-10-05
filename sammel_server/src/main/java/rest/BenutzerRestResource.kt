package rest

import database.benutzer.BenutzerDao
import database.benutzer.Credentials
import org.jboss.logging.Logger
import shared.Security
import shared.Security.HashMitSalt
import java.lang.Exception
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response

@Path("benutzer")
open class BenutzerRestResource {
    private val LOG = Logger.getLogger(this::class.java)

    @EJB
    private lateinit var dao: BenutzerDao

    @EJB
    private lateinit var security: Security

    @POST
    @Path("neu")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun legeNeuenBenutzerAn(login: Login): Response {
        val benutzer = login.user
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        if (login.firebaseKey.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Firebase Key darf nicht leer sein"))
                    .build()
        }

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
            dao.legeNeueCredentialsAn(Credentials(benutzerAusDb.id, hashMitSalt.hash, hashMitSalt.salt, login.firebaseKey!!))

            return Response.ok().entity(benutzerAusDb).build()
        } catch (e: Exception) {
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        }
    }

    @POST
    @Path("aktualisiere")
    @Produces(APPLICATION_JSON)
    open fun aktualisiereBenutzer(benutzerDto: BenutzerDto): Response {
        if(benutzerDto.id == null || benutzerDto.id == 0L) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Der Benutzer ist noch nicht angelegt"))
                    .build()
        }
        if(benutzerDto.name.isNullOrBlank()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        }
        val aktualisierterBenutzer = dao.aktualisiereUser(benutzerDto.convertToBenutzer())
        return Response
                .status(200)
                .entity(BenutzerDto.convertFromBenutzer(aktualisierterBenutzer))
                .build()
    }

    @POST
    @Path("authentifiziere")
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
        val verifiziert: Boolean?
        try {
            verifiziert = security.verifiziereSecretMitHash(login.secret!!, HashMitSalt(credentials.secret, credentials.salt))
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