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
        ***REMOVED***
        if (login.firebaseKey.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Firebase Key darf nicht leer sein"))
                    .build()
        ***REMOVED***

        // Zum Vermeiden optisch ähnlicher Namen
        login.user.name = login.user.name?.trim()

        if (benutzer.name != null && dao.benutzernameExistiert(benutzer.name!!)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername ist bereits vergeben"))
                    .build()
        ***REMOVED***
        try {
            val benutzerAusDb = dao.legeNeuenBenutzerAn(benutzer.convertToBenutzer())

            val hashMitSalt = security.hashSecret(login.secret!!)
            dao.legeNeueCredentialsAn(Credentials(benutzerAusDb.id, hashMitSalt.hash, hashMitSalt.salt, login.firebaseKey!!))

            return Response.ok().entity(benutzerAusDb).build()
        ***REMOVED*** catch (e: Exception) {
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        ***REMOVED***
    ***REMOVED***

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
        ***REMOVED***
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        ***REMOVED***
        val credentials: Credentials?
        try {
            credentials = dao.getCredentials(benutzer.id!!)
        ***REMOVED*** catch (e: java.lang.IllegalArgumentException) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID ist ungültig"))
                    .build()
        ***REMOVED***
        if (credentials == null) {
            LOG.info("Login mit unbekanntem Benutzer ${login.user.id***REMOVED***")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        ***REMOVED***
        if (!security.verifiziereSecretMitHash(login.secret!!, HashMitSalt(credentials.secret, credentials.salt))) {
            LOG.info("Falscher Login mit Benutzer ${login.user.id***REMOVED***")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        ***REMOVED***
        return Response
                .ok()
                .entity(true)
                .build()
    ***REMOVED***
***REMOVED***