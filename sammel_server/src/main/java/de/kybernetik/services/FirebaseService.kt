package de.kybernetik.services

import com.google.firebase.messaging.*
import org.jboss.logging.Logger
import de.kybernetik.rest.PushNotificationDto
import java.lang.Exception
import javax.ejb.EJB
import javax.ejb.Startup
import javax.ejb.Stateless

@Startup
@Stateless
open class FirebaseService {
    private val LOG = Logger.getLogger(FirebaseService::class.java)

    @EJB
    private lateinit var firebase: Firebase

    open fun sendePushNachrichtAnEmpfaenger(
        notification: PushNotificationDto?,
        data: Map<String, String>?,
        empfaenger: List<String>
    ) {
        LOG.debug("Sende Nachricht $notification/$data an Empfänger $empfaenger")

        if (empfaenger.isEmpty())
            throw MissingMessageTarget("Die Nachricht enthält keine Empfänger")

        if (empfaenger.size > 500) throw TooManyRecipientsError()

        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-multiple-devices
        var pushResponse: BatchResponse? = null
        if (notification != null) {
            val pushMessage = MulticastMessage.builder()
                .setNotification(
                    Notification.builder()
                        .setTitle(notification.title)
                        .setBody(notification.body)
                        .build())
                .setAndroidConfig(
                    AndroidConfig.builder().setNotification(
                        AndroidNotification.builder()
                            .setTitle(notification.title)
                            .setBody(notification.body)
                            .setClickAction("FLUTTER_NOTIFICATION_CLICK")
                            .setChannelId(notification.channel)
                            .setTag(notification.collapseId)
                            .build())
                        .setCollapseKey(notification.collapseId)
                        .build())
                .setApnsConfig(
                    ApnsConfig.builder()
                        .setAps(Aps.builder().setThreadId(notification.collapseId).build())
                        .build())
                .putAllData(data ?: emptyMap())
                .addAllTokens(empfaenger.distinct())
                .build()
            pushResponse = firebase.sendMulticast(pushMessage)
        }
        LOG.debug(
            "${pushResponse?.successCount} Push-Nachrichten  wurden erfolgreich an Firebase versendet"
        )
    }

    open fun sendePushNachrichtAnTopic(notification: PushNotificationDto?, data: Map<String, String>?, topic: String) {
        if (topic.isEmpty())
            throw MissingMessageTarget("Die Nachricht enthält kein Topic")

        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics
        if (notification != null) {
            val pushMessage = Message.builder()
                .setNotification(
                    Notification.builder()
                        .setTitle(notification.title)
                        .setBody(notification.body)
                        .build())
                .setAndroidConfig(
                    AndroidConfig.builder().setNotification(
                        AndroidNotification.builder()
                            .setTitle(notification.title)
                            .setBody(notification.body)
                            .setClickAction("FLUTTER_NOTIFICATION_CLICK")
                            .setChannelId(notification.channel)
                            .setTag(notification.collapseId)
                            .build())
                        .setCollapseKey(notification.collapseId)
                        .build())
                .setApnsConfig(
                    ApnsConfig.builder()
                        .setAps(Aps.builder().setThreadId(notification.collapseId).build())
                        .build())
                .putAllData(data ?: emptyMap())
                .setTopic(topic)
                .build()
            val pushResponse = firebase.send(pushMessage)
            LOG.debug("Erfolgreich Nachricht an Topic $topic gesendet: $pushResponse")
        }
    }

    class MissingMessageTarget(message: String) : Exception(message)
    class TooManyRecipientsError : Exception("Nicht mehr als 500 Empfänger für eine Nachricht möglich")
}