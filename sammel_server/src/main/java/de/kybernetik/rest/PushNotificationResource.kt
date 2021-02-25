package de.kybernetik.rest

import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.database.subscriptions.SubscriptionDao
import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import de.kybernetik.services.PushService
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.Response.Status.FORBIDDEN
import javax.ws.rs.core.SecurityContext

@Path("push")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@Stateless
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

    @Path("action/{actionId}")
    @RolesAllowed("named")
    @POST
    open fun pushToParticipants(nachricht: PushMessageDto, @PathParam("actionId") actionId: Long): Response? {
        LOG.info("Pushe Nachricht für Aktion $actionId")
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer

        if ((teilnehmer == null || !(teilnehmer.map { it.id }.contains(context.userPrincipal.name.toLong())))) {
            LOG.debug("Benutzer ${context.userPrincipal.name} darf keine Push-Message an Aktion $actionId mit Teilnehmern ${teilnehmer?.map { it.id }} schicken")
            return Response
                .status(FORBIDDEN)
                .entity(RestFehlermeldung("Du bist nicht Teilnehmer*in dieser Aktion"))
                .build()
        }

        nachricht.notification?.channel = "Aktionen-Chats"
        nachricht.notification?.collapseId = "chat:action:${actionId}"
        nachricht.persistent = true

        pushService.sendePushNachrichtAnEmpfaenger(nachricht, teilnehmer)

        return Response.accepted().build()
    }

    @Path("topic/{topic}")
    @RolesAllowed("moderator")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) {
        LOG.info("Pushe Nachricht zu Topic $topic (unmodifiziert)")
        pushService.sendePushNachrichtAnTopic(nachricht, topic)
    }

    @Path("pull")
    @RolesAllowed("user")
    @GET
    open fun pullNotifications(): Response? {
        val userId = context.userPrincipal.name.toLong()
        LOG.debug("Push-Messages für Benutzer $userId abgefragt")

        val pushMessages =
            pushMessageDao.ladeAllePushMessagesFuerBenutzer(userId)
        LOG.debug("${pushMessages.size} PushMessages für Benutzer $userId geladen: ${pushMessages.map { it.id }}")

        pushMessageDao.loeschePushMessages(pushMessages)

        return Response
            .ok()
            .entity(pushMessages.map { PushMessageDto.convertFromPushMessage(it) })
            .build()
    }

    @Path("pull/subscribe")
    @RolesAllowed("user")
    @POST
    open fun subscribeToTopics(topics: List<String>): Response? {
        LOG.info("Benutzer ${context.userPrincipal.name} abboniert Topics $topics")
        subscriptionDao.subscribe(context.userPrincipal.name.toLong(), topics)

        return Response.ok().build()
    }

    @Path("pull/unsubscribe")
    @RolesAllowed("user")
    @POST
    open fun unsubscribeToTopics(topics: List<String>): Response? {
        LOG.info("Benutzer ${context.userPrincipal.name} deabboniert Topics $topics")
        subscriptionDao.unsubscribe(context.userPrincipal.name.toLong(), topics)

        return Response.ok().build()
    }
}