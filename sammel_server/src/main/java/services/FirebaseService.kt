package services

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.Message
import com.google.firebase.messaging.MulticastMessage
import com.google.firebase.messaging.Notification
import org.jboss.logging.Logger
import rest.PushNotificationDto
import java.io.FileInputStream
import javax.annotation.PostConstruct
import javax.ejb.Singleton
import javax.ejb.Startup

@Startup
@Singleton
open class FirebaseService {
    private val LOG = Logger.getLogger(FirebaseService::class.java)


    @PostConstruct
    @Suppress("unused")
    fun initializeFirebase() {
        val creds = FileInputStream("${System.getenv("JBOSS_HOME")***REMOVED***/standalone/configuration/sammel-app-firebase-adminsdk.json")

        FirebaseApp.initializeApp(FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(creds))
                .setDatabaseUrl("https://sammel-app.firebaseio.com")
                .build())
    ***REMOVED***

    open fun sendePushNachrichtAnEmpfaenger(notification: PushNotificationDto?, data: Map<String, String>?, empfaenger: List<String>) {
        LOG.debug("Sende Nachricht $notification/$data an Empfänger $empfaenger")
        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-multiple-devices
        val message = MulticastMessage.builder()
                .setNotification(
                        if (notification == null) null
                        else Notification.builder().setTitle(notification.title).setBody(notification.body).build())
                .putAllData(data)
                .addAllTokens(empfaenger)
                .build()
        val response = FirebaseMessaging.getInstance().sendMulticast(message)
        LOG.debug("${response.successCount***REMOVED***  Nachrichten wurden erfolgreich versendet")
    ***REMOVED***

    open fun sendePushNachrichtAnTopic(notification: PushNotificationDto?, data: Map<String, String>?, topic: String) {
        LOG.debug("Sende Nachricht $notification/$data an Thema $topic")
        // Quelle: https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-topics
        val message: Message = Message.builder()
                .setNotification(
                        if (notification == null) null
                        else Notification.builder().setTitle(notification.title).setBody(notification.body).build())
                .putAllData(data)
                .setTopic(topic)
                .build()

        val response = FirebaseMessaging.getInstance().send(message)
        LOG.debug("Erfolgreich Nachricht an Topic $topic gesendet: $response")
    ***REMOVED***

    open fun sendeNachrichtAnAlle(notification: PushNotificationDto?, data: Map<String, String>?) =
            sendePushNachrichtAnTopic(notification, data, "global")
***REMOVED***