package rest

import services.FirebaseService
import java.lang.Exception
import javax.ejb.EJB
import javax.ws.rs.Consumes
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType

@Path("push")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
open class PushNotificationResource {

    @EJB
    private lateinit var firebase: FirebaseService

    @Path("devices")
    @POST
    open fun pushToDevices(nachricht: PushMessageDto) {
        if (nachricht.recipients.isNullOrEmpty())
            throw MissingMessageTarget("Die Nachricht enthält keine Empfänger")
        firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, nachricht.data, nachricht.recipients!!)
    }

    @Path("topic")
    @POST
    open fun pushToTopic(nachricht: PushMessageDto) {
        if (nachricht.topic.isNullOrEmpty())
            throw MissingMessageTarget("Die Nachricht enthält kein Topic")
        firebase.sendePushNachrichtAnTopic(nachricht.notification, nachricht.data, nachricht.topic!!)
    }

    class MissingMessageTarget(message: String) : Exception(message)
}