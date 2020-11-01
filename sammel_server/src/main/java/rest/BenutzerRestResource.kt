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
        ***REMOVED***
        if (login.firebaseKey.isNullOrEmpty()) login.firebaseKey = "no-key"

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
            dao.legeNeueCredentialsAn(Credentials(
                    benutzerAusDb.id,
                    hashMitSalt.hash,
                    hashMitSalt.salt,
                    login.firebaseKey!!,
                    listOf("app", "user")))

            return Response.ok().entity(benutzerAusDb).build()
        ***REMOVED*** catch (e: Exception) {
            LOG.error("Fehler beim Anlegen eines Benutzers: $benutzer", e)
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        ***REMOVED***
    ***REMOVED***

    @POST
    @Path("aktualisiere")
    @Produces(APPLICATION_JSON)
    open fun aktualisiereBenutzer(benutzerDto: BenutzerDto): Response {
        if(benutzerDto.id == null || benutzerDto.id == 0L) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Der Benutzer ist noch nicht angelegt"))
                    .build()
        ***REMOVED***
        if(benutzerDto.name.isNullOrBlank()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        ***REMOVED***
        val aktualisierterBenutzer = dao.aktualisiereUser(benutzerDto.convertToBenutzer())
        return Response
                .status(200)
                .entity(BenutzerDto.convertFromBenutzer(aktualisierterBenutzer))
                .build()
    ***REMOVED***

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
        LOG.warn(credentials.roles)
        val verifiziert: Boolean?
        try {
            verifiziert = security.verifiziereSecretMitHash(login.secret!!, Security.HashMitSalt(credentials.secret, credentials.salt))
        ***REMOVED*** catch (e: Exception) {
            val meldung = "Technischer Fehler beim Verifizieren: ${e.localizedMessage***REMOVED***"
            LOG.info(meldung)
            return Response.status(500).entity(RestFehlermeldung(meldung)).build()
        ***REMOVED***

        if (!verifiziert) {
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