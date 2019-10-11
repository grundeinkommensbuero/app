package rest

import database.benutzer.BenutzerDao
import org.hibernate.validator.internal.util.StringHelper.isNullOrEmptyString
import org.jboss.logging.Logger
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response

@Path("benutzer")
open class BenutzerRestResource {
    private val LOG = Logger.getLogger(this::class.java)

    @EJB
    private lateinit var dao: BenutzerDao

    @GET
    @Produces(APPLICATION_JSON)
    open fun getBenutzer(@QueryParam("name") name: String?): Response {
        if (isNullOrEmptyString(name)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Parameter 'name' fehlt oder ist leer"))
                    .build()
        ***REMOVED***
        try {
            val ergebnis = dao.getBenutzer(name!!)
            if (ergebnis == null) {
                return Response
                        .status(404)
                        .entity(RestFehlermeldung("Benutzer nicht vorhanden"))
                        .build()

            ***REMOVED*** else {
                return Response
                        .ok()
                        .entity(ergebnis)
                        .build()
            ***REMOVED***
        ***REMOVED*** catch (fehler: BenutzerDao.BenutzerMehrfachVorhandenException) {
            return Response
                    .serverError()
                    .entity(RestFehlermeldung(fehler.message))
                    .build()
        ***REMOVED***
    ***REMOVED***

    @POST
    @Path("neu")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun legeNeuenBenutzerAn(login: Login): Response {
        val benutzer = login.benutzer
        if (isNullOrEmptyString(benutzer.name)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        ***REMOVED***
        if (dao.getBenutzer(benutzer.name!!) == null) {
            dao.legeNeuenBenutzerAn(benutzer.convertToBenutzer(login.passwortHash))
            return Response.ok().build()
        ***REMOVED*** else {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername bereits vergeben"))
                    .build()
        ***REMOVED***
    ***REMOVED***

    @POST
    @Path("authentifiziere")
    @Produces(APPLICATION_JSON)
    open fun authentifiziereBenutzer(login: Login): Response {
        val benutzer = login.benutzer
        if (isNullOrEmptyString(benutzer.name)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        ***REMOVED***
        val benutzerAusDb = dao.getBenutzer(benutzer.name!!)
        if (benutzerAusDb == null) {
            return Response
                    .status(401)
                    .entity(RestFehlermeldung("Unbekannter Nutzername"))
                    .build()
        ***REMOVED***
        if (!benutzerAusDb.passwort.equals(login.passwortHash)) {
            LOG.info("Falscher Login mit Benutzer ${login.benutzer.id***REMOVED***")
            return Response
                    .status(401)
                    .entity(RestFehlermeldung("{Security***REMOVED*** Nutzername und Passwort stimmen nicht überein"))
                    .build()
        ***REMOVED***
        return Response
                .ok()
                .build()
    ***REMOVED***
***REMOVED***