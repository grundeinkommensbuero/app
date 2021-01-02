package de.kybernetik.rest

import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.database.subscriptions.SubscriptionDao
import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import de.kybernetik.services.PushService
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
    private lateinit var pushService: PushService

    @EJB
    private lateinit var termineDao: TermineDao

    @EJB
    private lateinit var pushMessageDao: PushMessageDao

    @EJB
    private lateinit var subscriptionDao: SubscriptionDao

    @Context
    private lateinit var context: SecurityContext

    @Path("action/{actionId***REMOVED***")
    @RolesAllowed("named")
    @POST
    open fun pushToParticipants(nachricht: PushMessageDto, @PathParam("actionId") actionId: Long): Response? {
        LOG.debug("Pushe Nachricht für Aktion $actionId")
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer

        if ((teilnehmer == null || !(teilnehmer.map { it.id ***REMOVED***.contains(context.userPrincipal.name.toLong())))) {
            LOG.debug("Benutzer ${context.userPrincipal.name***REMOVED*** darf keine Push-Message an Aktion $actionId mit Teilnehmern ${teilnehmer?.map { it.id ***REMOVED******REMOVED*** schicken")
            return Response
                .status(FORBIDDEN)
                .entity(RestFehlermeldung("Du bist nicht Teilnehmer*in dieser Aktion"))
                .build()
        ***REMOVED***

        nachricht.notification?.channel = "Aktionen-Chats"
        nachricht.notification?.collapseId = "chat:action:${actionId***REMOVED***"

        pushService.sendePushNachrichtAnEmpfaenger(nachricht, teilnehmer)

        return Response.accepted().build()
    ***REMOVED***

    @Path("topic/{topic***REMOVED***")
    @RolesAllowed("named")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) =
        pushService.sendePushNachrichtAnTopic(nachricht, topic)

    @Path("pull")
    @RolesAllowed("user")
    @GET
    open fun pullNotifications(): Response? {
        val userId = context.userPrincipal.name.toLong()
        LOG.debug("Push-Messages für Benutzer $userId abgefragt")

        val pushMessages =
            pushMessageDao.ladeAllePushMessagesFuerBenutzer(userId)
        LOG.debug("${pushMessages.size***REMOVED*** PushMessages für Benutzer $userId geladen: ${pushMessages.map { it.id ***REMOVED******REMOVED***")

        pushMessageDao.loeschePushMessages(pushMessages)

        return Response
            .ok()
            .entity(pushMessages.map { PushMessageDto.convertFromPushMessage(it) ***REMOVED***)
            .build()
    ***REMOVED***

    @Path("pull/subscribe")
    @RolesAllowed("user")
    @POST
    open fun subscribeToTopics(topics: List<String>): Response? {
        subscriptionDao.subscribe(context.userPrincipal.name.toLong(), topics)

        return Response.ok().build()
    ***REMOVED***

    @Path("pull/unsubscribe")
    @RolesAllowed("user")
    @POST
    open fun unsubscribeToTopics(topics: List<String>): Response? {
        subscriptionDao.unsubscribe(context.userPrincipal.name.toLong(), topics)

        return Response.ok().build()
    ***REMOVED***
***REMOVED***