package rest

import database.benutzer.BenutzerDao
import database.termine.TermineDao
import services.FirebaseService
import services.FirebaseService.MissingMessageTarget
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.MediaType

@Path("push")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
open class PushNotificationResource {

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
        val teilnehmer = termineDao.getTermin(actionId)?.teilnehmer
        if (teilnehmer == null) return
        val empfaenger = benutzerDao.getFirebaseKeys(teilnehmer)
        if (empfaenger.isEmpty()) return
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, empfaenger)
    }

    @Path("topic/{topic}")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto, @PathParam("topic") topic: String) {
        firebase.sendePushNachrichtAnTopic(nachricht.notification, nachricht.data, topic)
    }
}