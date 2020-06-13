package rest

import database.benutzer.Benutzer
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
        val benutzer = login.benutzer
        if (benutzer.name.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        }
        if (login.secret.isEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        if (login.firebaseKey.isEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Firebase Key darf nicht leer sein"))
                    .build()
        }

        // Zum Vermeiden optisch ähnlicher Namen
        login.benutzer.name = login.benutzer.name!!.trim()

        if(dao.benutzernameExistiert(benutzer.name!!)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername ist bereits vergeben"))
                    .build()
        }
        try {
            val benutzerAusDb = dao.legeNeuenBenutzerAn(benutzer.convertToBenutzer())

            val hashMitSalt = security.hashSecret(login.secret)
            dao.legeNeueCredentialsAn(Credentials(benutzerAusDb.id, hashMitSalt.hash, hashMitSalt.salt, login.firebaseKey))

            return Response.ok().entity(benutzerAusDb).build()
        } catch (e: Exception) {
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        }
    }

    @POST
    @Path("authentifiziere")
    @Produces(APPLICATION_JSON)
    open fun authentifiziereBenutzer(login: Login): Response {
        val benutzer = login.benutzer
        if (benutzer.id == null) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID darf nicht leer sein"))
                    .build()
        }
        if (login.secret.isEmpty()) {
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
            return Response
                    .status(401)
                    .entity(RestFehlermeldung("Unbekannter Benutzer"))
                    .build()
        }
        if (!security.verifiziereSecretMitHash(login.secret, HashMitSalt(credentials.secret, credentials.salt))) {
            LOG.info("Falscher Login mit Benutzer ${login.benutzer.id}")
            return Response
                    .status(401)
                    .entity(RestFehlermeldung("Nutzername und Passwort stimmen nicht überein"))
                    .build()
        }
        return Response
                .ok()
                .build()
    }
}