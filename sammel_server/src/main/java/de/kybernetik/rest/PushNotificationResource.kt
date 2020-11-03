package de.kybernetik.rest

import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import de.kybernetik.services.FirebaseService
import de.kybernetik.services.FirebaseService.MissingMessageTarget
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

    @EJB
    private lateinit var pushMessageDao: PushMessageDao

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
        LOG.debug("Pushe Nachricht für Aktion $actionId")
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer

        if ((teilnehmer == null || !(teilnehmer.map { it.id ***REMOVED***.contains(context.userPrincipal.name.toLong())))) {
            return Response
                    .status(FORBIDDEN)
                    .entity(RestFehlermeldung("Du bist nicht Teilnehmer dieser Aktion"))
                    .build()
        ***REMOVED***

        val firebaseKeys = benutzerDao.getFirebaseKeys(teilnehmer)
        val empfaengerOhneFirebase = benutzerDao.getBenutzerOhneFirebase(teilnehmer)
        LOG.debug("Pushe Nachricht an ${firebaseKeys.size***REMOVED*** Firebase-Keys und ${empfaengerOhneFirebase.size***REMOVED*** weitere Benutzer")

        if (firebaseKeys.isEmpty() && empfaengerOhneFirebase.isEmpty()) return Response.accepted().build()
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, firebaseKeys)

        if (empfaengerOhneFirebase.isEmpty()) return Response.accepted().build()
        pushMessageDao.speicherePushMessageFuerEmpfaenger(nachricht, empfaengerOhneFirebase)

        LOG.debug("Pushe-Nachricht-Versand für Aktion $actionId abgeschlossen")
        return Response.accepted().build()
    ***REMOVED***

    @Path("topic/{topic***REMOVED***")
    @RolesAllowed("named")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) {
        firebase.sendePushNachrichtAnTopic(nachricht.notification, nachricht.data, topic)
    ***REMOVED***

    @Path("pull")
    @RolesAllowed("user")
    @GET
    open fun pullNotifications(): Response? {
        val userId = context.userPrincipal.name.toLong()
        LOG.debug("Push-Messages für Benutzer $userId abgefragt")

        val pushMessages =
                pushMessageDao.ladeAllePushMessagesFuerBenutzer(userId)
                        .map { PushMessageDto.convertFromPushMessage(it) ***REMOVED***
        LOG.debug("${pushMessages.size***REMOVED*** PushMessages für Benutzer $userId geladen")

        return Response
                .ok()
                .entity(pushMessages)
                .build()
    ***REMOVED***
***REMOVED***