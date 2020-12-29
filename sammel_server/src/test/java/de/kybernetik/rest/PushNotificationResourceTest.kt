package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import com.nhaarman.mockitokotlin2.anyOrNull
import com.nhaarman.mockitokotlin2.argumentCaptor
import com.nhaarman.mockitokotlin2.atLeastOnce
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.benutzer.Benutzer
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
import de.kybernetik.services.PushService
import java.util.Collections.singletonList
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

@ExperimentalStdlibApi
class PushNotificationResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var pushService: PushService

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

    @Test
    fun `pushToTopic sendet Nachricht an PushService weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val kanal = "Kanal"

        val nachricht = PushMessageDto(notification, emptyMap<String, String>())
        resource.pushToTopic(nachricht, topic = kanal)

        val notificationCaptor = argumentCaptor<PushNotificationDto>()
        val dataCaptor = argumentCaptor<PushMessageDto>()
        val empfaengerCaptor = argumentCaptor<String>()
        verify(pushService, atLeastOnce()).sendePushNachrichtAnTopic(notificationCaptor.capture(), dataCaptor.capture(), empfaengerCaptor.capture())
        assertEquals(dataCaptor.firstValue, nachricht)
        assertEquals(notificationCaptor.firstValue, notification)
        assertEquals(empfaengerCaptor.firstValue, kanal)
    }

    @Test
    fun `pushToTopic sendet Nachricht an PushService weiter ohne Daten und Benachrichtigung`() {
        val kanal = "Kanal"

        val nachricht = PushMessageDto(null, null)
        resource.pushToTopic(nachricht, topic = kanal)

        verify(pushService, atLeastOnce()).sendePushNachrichtAnTopic(null, nachricht, kanal)
    }

    @Test
    fun `pushToTopic sendet Nachricht an PushService mit gefuellten Daten und Benachrichtigung`() {
        val notification = PushNotificationDto("Titel", "Inhalt")
        val data = mapOf(Pair("schlüssel1", "inhalt1"), Pair("schlüssel2", "inhalt2"))

        resource.pushToTopic(PushMessageDto(notification, data), topic = "Kanal")

        val notificationArgument = argumentCaptor<PushNotificationDto>()
        val dataArgument = argumentCaptor<PushMessageDto>()
        val topicArgument = argumentCaptor<String>()
        verify(pushService, times(1))
                .sendePushNachrichtAnTopic(notificationArgument.capture(), dataArgument.capture(), topicArgument.capture())
        assertEquals(notificationArgument.firstValue.title, "Titel")
        assertEquals(notificationArgument.firstValue.body, "Inhalt")
        assertEquals(dataArgument.firstValue.data!!, data)
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
        assertEquals("Du bist nicht Teilnehmer*in dieser Aktion", (response.entity as RestFehlermeldung).meldung)
        verify(pushService, never()).sendePushNachrichtAnEmpfaenger(anyOrNull(), anyOrNull(), anyList())

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
        verify(pushService, never()).sendePushNachrichtAnEmpfaenger(anyOrNull(), anyOrNull(), anyList())
    }

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

        val notificationCaptor = argumentCaptor<PushNotificationDto>()
        val dataCaptor = argumentCaptor<PushMessageDto>()
        val teilnehmerCaptor = argumentCaptor<List<Benutzer>>()
        verify(pushService, atLeastOnce()).sendePushNachrichtAnEmpfaenger(notificationCaptor.capture(), dataCaptor.capture(), teilnehmerCaptor.capture())
        assertTrue { dataCaptor.firstValue.data!!.isEmpty() }
        assertEquals(notificationCaptor.firstValue, notification)
        assertEquals(teilnehmerCaptor.firstValue, teilnehmer)
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

        resource.pullNotifications()

        verify(pushMessageDao, times(1)).loeschePushMessages(pushMessages)
    }

    @Test
    fun `pullNotifications liefert keine Empfaenger aus`() {
        whenever(pushMessageDao.ladeAllePushMessagesFuerBenutzer(11))
                .thenReturn(singletonList(PushMessage(karl(), emptyMap(), PushNotificationDto(title = "1"))))

        val response = resource.pullNotifications()

        @Suppress("UNCHECKED_CAST")
        (assertNull((response!!.entity as List<PushMessageDto>)[0].recipients))
    }
}