package de.kybernetik.services

import com.google.firebase.messaging.Message
import com.google.firebase.messaging.MulticastMessage
import com.google.firebase.messaging.Notification
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.termine.Termin
import org.jboss.logging.Logger
import de.kybernetik.rest.PushNotificationDto
import java.lang.Exception
import java.time.format.DateTimeFormatter
import javax.ejb.EJB
import javax.ejb.Singleton
import javax.ejb.Startup

@Startup
@Singleton
open class FirebaseService {
    private val LOG = Logger.getLogger(FirebaseService::class.java)

    @EJB
    private lateinit var benutzerDao: BenutzerDao

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
                .putAllData(data ?: emptyMap())
                .addAllTokens(empfaenger)
                .build()
        val response = firebase.sendMulticast(message)
        LOG.debug("${response?.successCount***REMOVED***  Nachrichten wurden erfolgreich an Firebase versendet")
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

        val response = firebase.send(message)
        LOG.debug("Erfolgreich Nachricht an Topic $topic gesendet: $response")
    ***REMOVED***

    open fun sendeNachrichtAnAlle(notification: PushNotificationDto?, data: Map<String, String>?) =
            sendePushNachrichtAnTopic(notification, data, "global")

    open fun informiereUeberTeilnahme(benutzer: Benutzer, aktion: Termin) {
        val empfaenger = benutzerDao.getFirebaseKeys(aktion.teilnehmer)
        val name = if (benutzer.name.isNullOrBlank()) "Jemand" else benutzer.name

        // Informiere Ersteller*in
        sendePushNachrichtAnEmpfaenger(
                PushNotificationDto("Verstärkung für deine Aktion",
                        "$name ist deiner Aktion vom ${aktion.beginn?.format(DateTimeFormatter.ofPattern("dd.MM."))***REMOVED*** " +
                                "beigetreten"),
                mapOf(Pair("action", aktion.id.toString())),
                listOf(empfaenger[0]))

        //Informiere Teilnehmer*innen
        sendePushNachrichtAnEmpfaenger(
                PushNotificationDto("Verstärkung für eure Aktion",
                        "$name ist der Aktion vom ${aktion.beginn?.format(DateTimeFormatter.ofPattern("dd.MM."))***REMOVED*** " +
                                "beigetreten, an der du teilnimmst"),
                mapOf(Pair("action", aktion.id.toString())),
                empfaenger.subList(1, empfaenger.size))
    ***REMOVED***

    open fun informiereUeberAbsage(benutzer: Benutzer, aktion: Termin) {
        val empfaenger = benutzerDao.getFirebaseKeys(aktion.teilnehmer)
        val name = if (benutzer.name.isNullOrBlank()) "Jemand" else benutzer.name

        // Informiere Ersteller*in
        sendePushNachrichtAnEmpfaenger(
                PushNotificationDto("Absage bei deiner Aktion",
                        "$name nimmt nicht mehr Teil an deiner Aktion vom ${aktion.beginn?.format(DateTimeFormatter.ofPattern("dd.MM."))***REMOVED***"),
                mapOf(Pair("action", aktion.id.toString())),
                listOf(empfaenger[0]))

        //Informiere Teilnehmer*innen
        if (empfaenger.size > 1)
            sendePushNachrichtAnEmpfaenger(
                    PushNotificationDto("Absage bei eurer Aktion",
                            "$name hat die Aktion vom ${aktion.beginn?.format(DateTimeFormatter.ofPattern("dd.MM."))***REMOVED*** " +
                                    "verlassen, an der du teilnimmst"),
                    mapOf(Pair("action", aktion.id.toString())),
                    empfaenger.subList(1, empfaenger.size))
    ***REMOVED***

    class MissingMessageTarget(message: String) : Exception(message)
    class TooManyRecipientsError : Exception("Nicht mehr als 500 Empfänger für eine Nachricht möglich")
***REMOVED***