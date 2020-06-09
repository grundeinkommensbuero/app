package rest

import com.nhaarman.mockitokotlin2.argumentCaptor
import com.nhaarman.mockitokotlin2.atLeastOnce
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import services.FirebaseService
import services.FirebaseService.MissingMessageTarget
import kotlin.test.assertEquals

class PushNotificationResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var firebase: FirebaseService

    @InjectMocks
    lateinit var resource: PushNotificationResource

    @Test(expected = MissingMessageTarget::class)
    fun `pushToDevices erwartet Empfaenger`() =
            resource.pushToDevices(PushMessageDto(notification = PushNotificationDto(), data = emptyMap()))

    @Test()
    fun `pushToDevices sendet Nachricht an Firebase weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(notification, data, recipients = empfaenger))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(notification, data, empfaenger)
    }

    @Test()
    fun `pushToDevices sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val empfaenger = listOf("Empfänger")

        resource.pushToDevices(PushMessageDto(null, null, recipients = empfaenger))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnEmpfaenger(null, null, empfaenger)
    }

    @Test()
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

    @Test(expected = MissingMessageTarget::class)
    fun `pushToTopic erwartet Topic`() =
            resource.pushToTopic(PushMessageDto(notification = PushNotificationDto(), data = emptyMap()))

    @Test()
    fun `pushToTopic sendet Nachricht an Firebase weiter mit leeren Daten und Benachrichtigung`() {
        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(notification, data, topic = kanal))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(notification, data, kanal)
    }

    @Test()
    fun `pushToTopic sendet Nachricht an Firebase weiter ohne Daten und Benachrichtigung`() {
        val kanal = "Kanal"

        resource.pushToTopic(PushMessageDto(null, null, topic = kanal))

        verify(firebase, atLeastOnce()).sendePushNachrichtAnTopic(null, null, kanal)
    }

    @Test()
    fun `pushToTopic sendet Nachricht an Firebase mit gefuellten Daten und Benachrichtigung`() {
        val notification = PushNotificationDto("Titel", "Inhalt")
        val data = mapOf(Pair("schlüssel1", "inhalt1"), Pair("schlüssel2", "inhalt2"))

        resource.pushToTopic(PushMessageDto(notification, data, topic = "Kanal"))

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
}