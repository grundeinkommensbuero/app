package rest

import database.benutzer.BenutzerDao
import database.termine.TermineDao
import org.jboss.logging.Logger
import services.FirebaseService
import services.FirebaseService.MissingMessageTarget
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.MediaType

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

    @Path("devices")
    @POST
    open fun pushToDevices(nachricht: PushMessageDto) {
        if (nachricht.recipients == null)
            throw MissingMessageTarget("Die Nachricht enthält keine Empfänger")
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, nachricht.recipients!!)
    }

    @Path("action/{actionId}")
    @POST
    open fun pushToParticipants(nachricht: PushMessageDto, @PathParam("actionId") actionId: Long) {
        LOG.info("Pushe Nachricht für Aktion $actionId")
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer
        if (teilnehmer == null) return
        val empfaenger = benutzerDao.getFirebaseKeys(teilnehmer)
        if (empfaenger.isEmpty()) return
        LOG.info("Pushe Nachricht an Keys $empfaenger")
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, empfaenger)
    }

    @Path("topic/{topic}")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) {
        firebase.sendePushNachrichtAnTopic(nachricht.notification, nachricht.data, topic)
    }
}