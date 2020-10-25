package services

import TestdatenVorrat
import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.terminMitTeilnehmerOhneDetails
import com.google.firebase.messaging.BatchResponse
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.MulticastMessage
import com.google.firebase.messaging.Notification
import com.nhaarman.mockitokotlin2.*
import database.benutzer.Benutzer
import database.benutzer.BenutzerDao
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.PushNotificationDto
import services.FirebaseService.MissingMessageTarget
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class FirebaseServiceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var firebase: Firebase

    @Mock
    private lateinit var benutzerDao: BenutzerDao

    @InjectMocks
    lateinit var service: FirebaseService

    @Test(expected = MissingMessageTarget::class)
    fun `sendePushNachrichtAnEmpfaenger erwartet nichtleere Liste von Empfaenger`() =
            service.sendePushNachrichtAnEmpfaenger(notification = PushNotificationDto(), data = emptyMap(), empfaenger = emptyList())

    @Test(expected = FirebaseService.TooManyRecipientsError::class)
    fun `sendePushNachrichtAnEmpfaenger erwartet nimmt nicht mehr als 500 Empfaenger an`() =
            service.sendePushNachrichtAnEmpfaenger(notification = PushNotificationDto(), data = emptyMap(), empfaenger = (1..501).map(Int::toString))

    @Test
    fun `sendePushNachrichtAnEmpfaenger schickt eine Nachricht an jeden Empfaeger`() {
        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(), emptyMap(), (1..50).map { Int.toString() ***REMOVED***)

        verify(firebaseMock, times(1)).sendMulticast(any())
    ***REMOVED***

    @Test(expected = MissingMessageTarget::class)
    fun `sendePushNachrichtAnTopic erwartet  nichtleeres Topic`() =
            service.sendePushNachrichtAnTopic(notification = PushNotificationDto(), data = emptyMap(), topic = "")

    @Test
    fun `sendePushNachrichtAnTopic schickt eine Nachricht ab`() {
        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)

        service.sendePushNachrichtAnTopic(PushNotificationDto(), emptyMap(), "topic")

        verify(firebaseMock, times(1)).send(any())
    ***REMOVED***

    @Test
    fun `sendeNachrichtAnAlle schickt eine Nachricht ab`() {
        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)

        service.sendeNachrichtAnAlle(PushNotificationDto(), emptyMap())

        verify(firebaseMock, times(1)).send(any())
    ***REMOVED***

    @Test
    fun `informiereUeberTeilnahme informiert Ersteller*in`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseBini"))

        service.informiereUeberTeilnahme(Benutzer(13, "Bini Adamczak", 3), terminMitTeilnehmerOhneDetails())

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())

        assertEquals("Verstärkung für deine Aktion", getMulticastTitle(message.firstValue))
        assertEquals("Bini Adamczak ist deiner Aktion vom 22.10. beigetreten", getMulticastBody(message.firstValue))
        assertEquals((getMulticastData(message.firstValue).size), 1)
        assertEquals(getMulticastData(message.firstValue)["action"], "2")
        assertTrue(getMulticastTokens(message.firstValue).containsAll(listOf("firebaseKarl")))
    ***REMOVED***

    @Test
    fun `informiereUeberTeilnahme ersetzt fehlenden Namen mit Jemand`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseBini"))

        service.informiereUeberTeilnahme(Benutzer(13, null, 3), terminMitTeilnehmerOhneDetails())

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())
        assertEquals("Jemand ist deiner Aktion vom 22.10. beigetreten", getMulticastBody(message.firstValue))
        assertEquals("Jemand ist der Aktion vom 22.10. beigetreten, an der du teilnimmst", getMulticastBody(message.lastValue))
    ***REMOVED***

    @Test
    fun `informiereUeberAbsage ersetzt leeren Namen mit Jemand`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseBini"))

        service.informiereUeberAbsage(Benutzer(13, "", 3), terminMitTeilnehmerOhneDetails())

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())
        assertEquals("Jemand nimmt nicht mehr Teil an deiner Aktion vom 22.10.", getMulticastBody(message.firstValue))
        assertEquals("Jemand hat die Aktion vom 22.10. verlassen, an der du teilnimmst", getMulticastBody(message.lastValue))
    ***REMOVED***

    @Test
    fun `informiereUeberTeilnahme informiert alte und neue Teilnehmer*innen extra`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseRosa", "firebaseBini"))

        val aktion = terminMitTeilnehmerOhneDetails()
        aktion.teilnehmer = listOf(karl(), rosa())
        service.informiereUeberTeilnahme(Benutzer(13, "Bini Adamczak", 3), aktion)

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())

        assertEquals("Verstärkung für eure Aktion", getMulticastTitle(message.lastValue))
        assertEquals("Bini Adamczak ist der Aktion vom 22.10. beigetreten, an der du teilnimmst", getMulticastBody(message.lastValue))
        assertEquals((getMulticastData(message.lastValue).size), 1)
        assertEquals(getMulticastData(message.lastValue)["action"], "2")
        assertTrue(getMulticastTokens(message.lastValue).containsAll(listOf("firebaseRosa", "firebaseBini")))
    ***REMOVED***

    @Test
    fun `informiereUeberAbsage informiert Ersteller*in extra`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseBini"))

        val aktion = terminMitTeilnehmerOhneDetails()
        val bini = Benutzer(13L, "Bini Adamczak", 3)
        aktion.teilnehmer = listOf(karl(), rosa(), bini)

        service.informiereUeberAbsage(bini, aktion)

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())

        assertEquals("Absage bei deiner Aktion", getMulticastTitle(message.firstValue))
        assertEquals("Bini Adamczak nimmt nicht mehr Teil an deiner Aktion vom 22.10.", getMulticastBody(message.firstValue))
        assertEquals((getMulticastData(message.firstValue).size), 1)
        assertEquals(getMulticastData(message.firstValue)["action"], "2")
        assertTrue(getMulticastTokens(message.firstValue).containsAll(listOf("firebaseKarl")))
    ***REMOVED***

    @Test
    fun `informiereUeberAbsage informiert verbleibende Teilnehmer*innen extra`() {

        val firebaseMock = mock<FirebaseMessaging>()
        whenever(firebase.instance()).thenReturn(firebaseMock)
        val reponseMock = mock<BatchResponse>()
        whenever(firebaseMock.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(listOf("firebaseKarl", "firebaseRosa"))

        val aktion = terminMitTeilnehmerOhneDetails()
        val bini = Benutzer(13L, "Bini Adamczak", 3)
        aktion.teilnehmer = listOf(karl(), rosa(), bini)

        service.informiereUeberAbsage(bini, aktion)

        val message = argumentCaptor<MulticastMessage>()
        verify(firebaseMock, times(2)).sendMulticast(message.capture())

        assertEquals("Absage bei eurer Aktion", getMulticastTitle(message.lastValue))
        assertEquals("Bini Adamczak hat die Aktion vom 22.10. verlassen, an der du teilnimmst", getMulticastBody(message.lastValue))
        assertEquals((getMulticastData(message.lastValue).size), 1)
        assertEquals(getMulticastData(message.lastValue)["action"], "2")
        assertTrue(getMulticastTokens(message.lastValue).containsAll(listOf("firebaseRosa")))
    ***REMOVED***

    fun getMulticastTitle(multicast: MulticastMessage): String {
        val notificationField = MulticastMessage::class.java.getDeclaredField("notification")
        val titleField = Notification::class.java.getDeclaredField("title")
        notificationField.isAccessible = true
        titleField.isAccessible = true

        val notification = notificationField.get(multicast) as Notification
        return titleField.get(notification) as String
    ***REMOVED***

    fun getMulticastBody(multicast: MulticastMessage): String {
        val notificationField = MulticastMessage::class.java.getDeclaredField("notification")
        val bodyField = Notification::class.java.getDeclaredField("body")
        notificationField.isAccessible = true
        bodyField.isAccessible = true

        val notification = notificationField.get(multicast) as Notification
        return bodyField.get(notification) as String
    ***REMOVED***

    fun getMulticastData(multicast: MulticastMessage): Map<String, String> {
        val dataField = MulticastMessage::class.java.getDeclaredField("data")
        dataField.isAccessible = true

        @Suppress("UNCHECKED_CAST")
        return dataField.get(multicast) as Map<String, String>
    ***REMOVED***

    fun getMulticastTokens(multicast: MulticastMessage): List<String> {
        val tokensField = MulticastMessage::class.java.getDeclaredField("tokens")
        tokensField.isAccessible = true

        @Suppress("UNCHECKED_CAST")
        return tokensField.get(multicast) as List<String>
    ***REMOVED***
***REMOVED***