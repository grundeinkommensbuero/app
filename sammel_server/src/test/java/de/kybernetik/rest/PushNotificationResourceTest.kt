package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import com.nhaarman.mockitokotlin2.argumentCaptor
import com.nhaarman.mockitokotlin2.atLeastOnce
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessage
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TermineDao
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.services.FirebaseService
import de.kybernetik.services.FirebaseService.MissingMessageTarget
import de.kybernetik.services.PushService
import java.util.Collections.singletonList
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class PushNotificationResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var pushService: PushService

    @Mock
    lateinit var firebase: FirebaseService

    @Mock
    lateinit var termineDao: TermineDao

    @Mock
    lateinit var benutzerDao: BenutzerDao

    @Mock
    lateinit var pushMessageDao: PushMessageDao

    @Mock
    lateinit var context: SecurityContext

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
    ***REMOVED***

    @InjectMocks
    lateinit var resource: PushNotificationResource

    @Test(expected = MissingMessageTarget::class)
    fun `pushToDevices erwartet Empfaenger`() =
            resource.pushToDevices(PushMessageDto(notification = PushNotificationDto(), data = emptyMap()))

    @Test
    fun `pushToDevices sendet Nachricht an Firebase weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(notification, data, recipients = empfaenger))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(notification, data, empfaenger)
    ***REMOVED***

    @Test
    fun `pushToDevices sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(null, null, recipients = empfaenger))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(null, null, empfaenger)
    ***REMOVED***

    @Test
    fun `pushToDevices sendet Nachricht an Firebase mit gefuellten Daten und Benachrichtigung`() {
        val notification = PushNotificationDto("Titel", "Inhalt")
        val data = mapOf(Pair("schlüssel1", "inhalt1"), Pair("schlüssel2", "inhalt2"))
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(notification, data, recipients = empfaenger))

        val notificationArgument = argumentCaptor<PushNotificationDto>()
        val dataArgument = argumentCaptor<Map<String, String>>()
        val empfaengerArgument = argumentCaptor<List<String>>()
        verify(firebase, times(1))
                .sendePushNachrichtAnEmpfaenger(notificationArgument.capture(), dataArgument.capture(), empfaengerArgument.capture())
        assertEquals(notificationArgument.firstValue.title, "Titel")
        assertEquals(notificationArgument.firstValue.body, "Inhalt")
        assertEquals(dataArgument.firstValue.size, 2)
        assertEquals(dataArgument.firstValue["schlüssel1"], "inhalt1")
        assertEquals(dataArgument.firstValue["schlüssel2"], "inhalt2")
        assertEquals(empfaengerArgument.firstValue.size, 1)
        assertEquals(empfaengerArgument.firstValue[0], "Empfänger")
    ***REMOVED***

    @Test
    fun `pushToTopic sendet Nachricht an Firebase weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(notification, data), topic = kanal)

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(notification, data, kanal)
    ***REMOVED***

    @Test
    fun `pushToTopic sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(null, null), topic = kanal)

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(null, null, kanal)
    ***REMOVED***

    @Test
    fun `pushToTopic sendet Nachricht an Firebase mit gefuellten Daten und Benachrichtigung`() {
        val notification = PushNotificationDto("Titel", "Inhalt")
        val data = mapOf(Pair("schlüssel1", "inhalt1"), Pair("schlüssel2", "inhalt2"))

        resource.pushToTopic(PushMessageDto(notification, data), topic = "Kanal")

        val notificationArgument = argumentCaptor<PushNotificationDto>()
        val dataArgument = argumentCaptor<Map<String, String>>()
        val topicArgument = argumentCaptor<String>()
        verify(firebase, times(1))
                .sendePushNachrichtAnTopic(notificationArgument.capture(), dataArgument.capture(), topicArgument.capture())
        assertEquals(notificationArgument.firstValue.title, "Titel")
        assertEquals(notificationArgument.firstValue.body, "Inhalt")
        assertEquals(dataArgument.firstValue.size, 2)
        assertEquals(dataArgument.firstValue["schlüssel1"], "inhalt1")
        assertEquals(dataArgument.firstValue["schlüssel2"], "inhalt2")
        assertEquals(topicArgument.firstValue, "Kanal")
    ***REMOVED***

    @Test
    fun `pushToParticipants liefert 403, wenn User nicht Teilnehmer ist`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(anyList())).thenReturn(singletonList("firebase-key 1"))
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("12")) // rosa statt karl

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()

        var response = resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        assertEquals(response!!.status, 403)
        assertEquals("Du bist nicht Teilnehmer*in dieser Aktion", (response.entity as RestFehlermeldung).meldung)
        verify(firebase, never()).sendePushNachrichtAnEmpfaenger(any(), anyMap(), anyList())

        // ohne Teilnehmer
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        emptyList(),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(anyList())).thenReturn(singletonList("firebase-key 1"))
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("12")) // rosa statt karl

        response = resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        assertEquals(response!!.status, 403)
        assertEquals("Du bist nicht Teilnehmer*in dieser Aktion", (response.entity as RestFehlermeldung).meldung)
        verify(firebase, never()).sendePushNachrichtAnEmpfaenger(any(), anyMap(), anyList())
    ***REMOVED***

    @Test
    fun `pushToParticipants sendet Nachricht an PushService`() {
        val teilnehmer = singletonList(karl())
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        teilnehmer,
                        52.48612, 13.47192, null))

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()

        resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        verify(pushService, atLeastOnce()).sendePushNachrichtAnEmpfaenger(notification, data, teilnehmer)
    ***REMOVED***

    fun `pullNotifications liest Benutzer-ID aus Credentials`() {
        val pushMessages = listOf(
                PushMessage(karl(), emptyMap(), PushNotificationDto()),
                PushMessage(karl(), emptyMap(), PushNotificationDto()),
                PushMessage(karl(), emptyMap(), PushNotificationDto()))
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(pushMessages)

        resource.pullNotifications()

        verify(pushMessageDao, times(1)).ladeAllePushMessagesFuerBenutzer(11)
    ***REMOVED***

    @Test
    fun `pullNotifications liefert pushMessages aus`() {
        val pushMessages = listOf(
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "1")),
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "2")),
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "3")))
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(pushMessages)

        val response = resource.pullNotifications()

        assertEquals(response!!.status, 200)
        @Suppress("UNCHECKED_CAST")
        assertTrue((response.entity as List<PushMessageDto>)
                .map { it.notification!!.title ***REMOVED***
                .containsAll(listOf("1", "2", "3")))
    ***REMOVED***

    @Test
    fun `pullNotifications loescht Nachrichten in DB`() {
        val pushMessages = listOf(
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "1")),
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "2")),
                PushMessage(karl(), emptyMap(), PushNotificationDto(title = "3")))
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(pushMessages)

        val response = resource.pullNotifications()

        verify(pushMessageDao, times(1)).loeschePushMessages(pushMessages)
    ***REMOVED***

    @Test
    fun `pullNotifications liefert keine Empfaenger aus`() {
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(singletonList(PushMessage(karl(), emptyMap(), PushNotificationDto(title = "1"))))

        val response = resource.pullNotifications()

        @Suppress("UNCHECKED_CAST")
        (assertNull((response!!.entity as List<PushMessageDto>)[0].recipients))
    ***REMOVED***
***REMOVED***