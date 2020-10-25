package rest

import database.benutzer.BenutzerDao
import database.termine.TermineDao
import org.jboss.logging.Logger
import services.FirebaseService
import services.FirebaseService.MissingMessageTarget
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.Response.Status.FORBIDDEN
import javax.ws.rs.core.SecurityContext

@Path("push")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
open class PushNotificationResource {
    private val LOG = Logger.getLogger(PushNotificationResource::class.java)

    @EJB
    private lateinit var firebase: FirebaseService

    @EJB
    private lateinit var benutzerDao: BenutzerDao

    @EJB
    private lateinit var termineDao: TermineDao

    @Context
    private lateinit var context: SecurityContext

    @Path("devices")
    @RolesAllowed("named")
    @POST
    open fun pushToDevices(nachricht: PushMessageDto) {
        if (nachricht.recipients == null)
            throw MissingMessageTarget("Die Nachricht enthält keine Empfänger")
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, nachricht.recipients!!)
    ***REMOVED***

    @Path("action/{actionId***REMOVED***")
    @RolesAllowed("named")
    @POST
    open fun pushToParticipants(nachricht: PushMessageDto, @PathParam("actionId") actionId: Long): Response? {
        LOG.info("Pushe Nachricht für Aktion $actionId")
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer

        if ((teilnehmer == null || !(teilnehmer.map { it.id ***REMOVED***.contains(context.userPrincipal.name.toLong())))) {
            return Response
                    .status(FORBIDDEN)
                    .entity(RestFehlermeldung("Du bist nicht Teilnehmer dieser Aktion"))
                    .build()
        ***REMOVED***

        val empfaenger = benutzerDao.getFirebaseKeys(teilnehmer)
        if (empfaenger.isEmpty()) return Response.accepted().build()
        LOG.info("Pushe Nachricht an Keys $empfaenger")

        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, empfaenger)
        return Response.accepted().build()
    ***REMOVED***

    @Path("topic/{topic***REMOVED***")
    @RolesAllowed("named")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) {
        firebase.sendePushNachrichtAnTopic(nachricht.notification, nachricht.data, topic)
    ***REMOVED***
***REMOVED***