package de.kybernetik.services

import com.google.firebase.messaging.*
import org.jboss.logging.Logger
import de.kybernetik.rest.PushNotificationDto
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
        val dataMessage = MulticastMessage.builder()
            .putAllData(data ?: emptyMap())
            .addAllTokens(empfaenger.distinct())
            .build()
        val dataResponse = firebase.sendMulticast(dataMessage)

        var pushResponse: BatchResponse? = null
        if(notification != null) {
            val pushMessage = MulticastMessage.builder()
                .setNotification(Notification.builder()
                    .setTitle(notification.title)
                    .setBody(notification.body)
                    .build())
                .setAndroidConfig(AndroidConfig.builder().setNotification(AndroidNotification.builder()
                    .setTitle(notification.title)
                    .setBody(notification.body)
                    .setClickAction("FLUTTER_NOTIFICATION_CLICK")
                    .setChannelId(notification.channel)
                    .build())
                    .setCollapseKey(notification.collapseId)
                    .build())
                .putAllData(data ?: emptyMap())
                .addAllTokens(empfaenger.distinct())
                .build()
            pushResponse = firebase.sendMulticast(pushMessage)
        ***REMOVED***
        LOG.debug("${dataResponse?.successCount***REMOVED*** Data-Nachrichten und ${pushResponse?.successCount***REMOVED*** Push-Nachrichten  " +
                "wurden erfolgreich an Firebase versendet")
    ***REMOVED***

    open fun sendePushNachrichtAnTopic(notification: PushNotificationDto?, data: Map<String, String>?, topic: String) {
        LOG.debug("Sende Nachricht $notification/$data an Thema $topic")

        if (topic.isEmpty())
            throw MissingMessageTarget("Die Nachricht enthält kein Topic")

        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics
        val dataMessage: Message = Message.builder()
            .putAllData(data)
            .setTopic(topic)
            .build()
        val dataResponse = firebase.send(dataMessage)

        var pushResponse = "ohne Notification"
        if(notification != null) {
            val pushMessage = Message.builder()
                .setNotification(Notification.builder()
                    .setTitle(notification.title)
                    .setBody(notification.body)
                    .build())
                .setAndroidConfig(AndroidConfig.builder().setNotification(AndroidNotification.builder()
                    .setTitle(notification.title)
                    .setBody(notification.body)
                    .setClickAction("FLUTTER_NOTIFICATION_CLICK")
                    .setChannelId(notification.channel)
                    .build())
                    .setCollapseKey(notification.collapseId)
                    .build())
                .putAllData(data ?: emptyMap())
                .setTopic(topic)
                .build()
            pushResponse = firebase.send(pushMessage)
        ***REMOVED***
        LOG.debug("Erfolgreich Nachricht an Topic $topic gesendet: $dataResponse, $pushResponse")
    ***REMOVED***

    open fun sendeNachrichtAnAlle(notification: PushNotificationDto?, data: Map<String, String>?) =
        sendePushNachrichtAnTopic(notification, data, "global")

    class MissingMessageTarget(message: String) : Exception(message)
    class TooManyRecipientsError : Exception("Nicht mehr als 500 Empfänger für eine Nachricht möglich")
***REMOVED***