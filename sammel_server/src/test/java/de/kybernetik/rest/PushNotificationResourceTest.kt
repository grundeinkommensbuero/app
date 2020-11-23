package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
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
    }

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
    }

    @Test
    fun `pushToDevices sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(null, null, recipients = empfaenger))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(null, null, empfaenger)
    }

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
    }

    @Test
    fun `pushToTopic sendet Nachricht an Firebase weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(notification, data), topic = kanal)

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(notification, data, kanal)
    }

    @Test
    fun `pushToTopic sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(null, null), topic = kanal)

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(null, null, kanal)
    }

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
    }

    @Test
    fun `pushToParticipants sendet Nachricht an Firebase weiter an korrekten Teilnehmer`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(anyList())).thenReturn(singletonList("firebase-key 1"))

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()

        resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        verify(firebase, atLeastOnce())
                .sendePushNachrichtAnEmpfaenger(notification, data, singletonList("firebase-key 1"))
    }

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
        assertEquals((response.entity as RestFehlermeldung).meldung, "Du bist nicht Teilnehmer dieser Aktion")
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
        assertEquals((response.entity as RestFehlermeldung).meldung, "Du bist nicht Teilnehmer dieser Aktion")
        verify(firebase, never()).sendePushNachrichtAnEmpfaenger(any(), anyMap(), anyList())
    }

    @Test
    fun `pushToParticipants sendet Nachricht an Firebase weiter an mehrere Teilnehmer`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(singletonList(karl)))
                .thenReturn(listOf("firebase-key 1", "firebase-key 2", "firebase-key 3"))

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()

        resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(notification, data,
                listOf("firebase-key 1", "firebase-key 2", "firebase-key 3"))
    }

    @Test
    fun `pushToParticipants sendet Nachricht an Firebase weiter an keine Firebase-Keys`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(singletonList(karl))).thenReturn(emptyList())

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()

        resource.pushToParticipants(PushMessageDto(notification, data), actionId = 1L)

        verify(firebase, never()).sendePushNachrichtAnEmpfaenger(any(), any(), anyList())
    }

    @Test
    fun `pushToParticipants speichert Nachricht fuer Benutzer ohne Firebase`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(listOf(karl))).thenReturn(emptyList())
        whenever(benutzerDao.getBenutzerOhneFirebase(listOf(karl))).thenReturn(listOf(karl))

        val nachricht = PushMessageDto(PushNotificationDto(), emptyMap())
        resource.pushToParticipants(nachricht, actionId = 1L)

        verify(pushMessageDao, times(1)).speicherePushMessageFuerEmpfaenger(nachricht, singletonList(karl))
    }

    @Test
    fun `pushToParticipants speichert keine Nachricht wenn alle Benutzer Firebase nutzen`() {
        val karl = karl()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        singletonList(karl),
                        52.48612, 13.47192, null))
        whenever(benutzerDao.getFirebaseKeys(listOf(karl))).thenReturn(listOf("AAAAAAAAA"))
        whenever(benutzerDao.getBenutzerOhneFirebase(listOf(karl))).thenReturn(emptyList())

        val nachricht = PushMessageDto(PushNotificationDto(), emptyMap())
        resource.pushToParticipants(nachricht, actionId = 1L)

        verify(pushMessageDao, never()).speicherePushMessageFuerEmpfaenger(com.nhaarman.mockitokotlin2.any(), anyList())
    }

    @Test
    fun `pushToParticipants bedient Benutzer mit und ohne Firebase gleichzeitig`() {
        val karl = karl()
        val rosa = rosa()
        whenever(termineDao.getTermin(1L))
                .thenReturn(Termin(1, null, null, null, null,
                        listOf(karl, rosa),
                        52.48612, 13.47192, null))
        val firebaseListe = singletonList("AAAAAAAAAA")
        whenever(benutzerDao.getFirebaseKeys(listOf(karl, rosa))).thenReturn(firebaseListe)
        val ohenFirebaseListe = singletonList(rosa)
        whenever(benutzerDao.getBenutzerOhneFirebase(listOf(karl, rosa))).thenReturn(ohenFirebaseListe)

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val nachricht = PushMessageDto(notification, data)

        resource.pushToParticipants(nachricht, actionId = 1L)

        verify(firebase, times(1)).sendePushNachrichtAnEmpfaenger(notification, data, firebaseListe)
        verify(pushMessageDao, times(1)).speicherePushMessageFuerEmpfaenger(nachricht, ohenFirebaseListe)
    }

    @Test
    fun `pullNotifications liest Benutzer-ID aus Credentials`() {
        val pushMessages = listOf(
                PushMessage(karl(), emptyMap(), PushNotificationDto()),
                PushMessage(karl(), emptyMap(), PushNotificationDto()),
                PushMessage(karl(), emptyMap(), PushNotificationDto()))
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(pushMessages)

        resource.pullNotifications()

        verify(pushMessageDao, times(1)).ladeAllePushMessagesFuerBenutzer(11)
    }

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
                .map { it.notification!!.title }
                .containsAll(listOf("1", "2", "3")))
    }

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
    }

    @Test
    fun `pullNotifications liefert keine Empfaenger aus`() {
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(singletonList(PushMessage(karl(), emptyMap(), PushNotificationDto(title = "1"))))

        val response = resource.pullNotifications()

        @Suppress("UNCHECKED_CAST")
        (assertNull ((response!!.entity as List<PushMessageDto>)[0].recipients))
    }
}