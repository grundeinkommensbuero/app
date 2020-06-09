package services

import com.google.firebase.messaging.Message
import com.google.firebase.messaging.MulticastMessage
import com.google.firebase.messaging.Notification
import org.jboss.logging.Logger
import rest.PushNotificationDto
import java.lang.Exception
import javax.ejb.EJB
import javax.ejb.Singleton
import javax.ejb.Startup

@Startup
@Singleton
open class FirebaseService {
    private val LOG = Logger.getLogger(FirebaseService::class.java)

    @EJB
    private lateinit var firebase: Firebase

    open fun sendePushNachrichtAnEmpfaenger(notification: PushNotificationDto?, data: Map<String, String>?, empfaenger: List<String>) {
        LOG.debug("Sende Nachricht $notification/$data an Empfänger $empfaenger")

        if (empfaenger.isEmpty())
            throw MissingMessageTarget("Die Nachricht enthält keine Empfänger")

        if (empfaenger.size > 500) throw TooManyRecipientsError()

        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-multiple-devices
        val message = MulticastMessage.builder()
                .setNotification(
                        if (notification == null) null
                        else Notification.builder().setTitle(notification.title).setBody(notification.body).build())
                .putAllData(data)
                .addAllTokens(empfaenger)
                .build()
        val response = firebase.instance().sendMulticast(message)
        LOG.debug("${response.successCount***REMOVED***  Nachrichten wurden erfolgreich versendet")
    ***REMOVED***

    open fun sendePushNachrichtAnTopic(notification: PushNotificationDto?, data: Map<String, String>?, topic: String) {
        LOG.debug("Sende Nachricht $notification/$data an Thema $topic")

        if (topic.isEmpty())
            throw MissingMessageTarget("Die Nachricht enthält kein Topic")

        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics
        val message: Message = Message.builder()
                .setNotification(
                        if (notification == null) null
                        else Notification.builder().setTitle(notification.title).setBody(notification.body).build())
                .putAllData(data)
                .setTopic(topic)
                .build()

        val response = firebase.instance().send(message)
        LOG.debug("Erfolgreich Nachricht an Topic $topic gesendet: $response")
    ***REMOVED***

    open fun sendeNachrichtAnAlle(notification: PushNotificationDto?, data: Map<String, String>?) =
            sendePushNachrichtAnTopic(notification, data, "global")

    class MissingMessageTarget(message: String) : Exception(message)
    class TooManyRecipientsError: Exception("Nicht mehr als 500 Empfänger für eine Nachricht möglich")
***REMOVED***