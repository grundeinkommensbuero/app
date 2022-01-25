package de.kybernetik.services

import com.google.firebase.messaging.BatchResponse
import com.google.firebase.messaging.Message
import com.google.firebase.messaging.MulticastMessage
import com.nhaarman.mockitokotlin2.*
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.PushNotificationDto
import de.kybernetik.services.FirebaseService.MissingMessageTarget
import org.junit.Before
import java.lang.reflect.Field
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class FirebaseServiceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var firebase: Firebase

    @InjectMocks
    lateinit var service: FirebaseService

    // Advanced Reflections Voodoo
    val tokenField: Field = MulticastMessage::class.java.getDeclaredField("tokens")

    @Before
    fun setUp() {
        tokenField.isAccessible = true
    }

    @Test(expected = MissingMessageTarget::class)
    fun `sendePushNachrichtAnEmpfaenger erwartet nichtleere Liste von Empfaenger`() =
        service.sendePushNachrichtAnEmpfaenger(
            notification = PushNotificationDto(channel = "Allgemein", collapseId = null),
            data = emptyMap(),
            empfaenger = emptyList()
        )

    @Test(expected = FirebaseService.TooManyRecipientsError::class)
    fun `sendePushNachrichtAnEmpfaenger erwartet nimmt nicht mehr als 500 Empfaenger an`() =
        service.sendePushNachrichtAnEmpfaenger(
            notification = PushNotificationDto(channel = "Allgemein", collapseId = null),
            data = emptyMap(),
            empfaenger = (1..501).map(Int::toString)
        )

    @Test
    fun `sendePushNachrichtAnEmpfaenger schickt die Nachricht an jeden Empfaeger`() {
        val reponseMock = mock<BatchResponse>()
        whenever(firebase.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(channel = "Allgemein", collapseId = null), emptyMap(), (1..50).map { Int.toString() })

        val captor = argumentCaptor<MulticastMessage>()
        verify(firebase, times(1)).sendMulticast(captor.capture())
        @Suppress("UNCHECKED_CAST") val tokens = tokenField.get(captor.firstValue) as List<String>
        assertTrue(tokens.containsAll((1..50).map { Int.toString() }))
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger schickt keine Nachricht zweimal an denselben Empfaeger`() {
        val reponseMock = mock<BatchResponse>()
        whenever(firebase.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(channel = "Allgemein", collapseId = null), emptyMap(), listOf("1", "1", "1", "2", "2", "3"))

        val captor = argumentCaptor<MulticastMessage>()
        verify(firebase, times(1)).sendMulticast(captor.capture())
        @Suppress("UNCHECKED_CAST") val tokens = tokenField.get(captor.firstValue) as List<String>
        assertTrue(tokens.containsAll(listOf("1", "2", "3")))
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger akzeptiert leere Daten`() {
        val reponseMock = mock<BatchResponse>()
        whenever(firebase.sendMulticast(any())).thenReturn(reponseMock)
        whenever(reponseMock.successCount).thenReturn(50)

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(channel = "Allgemein", collapseId = null), null, (1..50).map { Int.toString() })

        verify(firebase, times(1)).sendMulticast(any())
    }

    @Test(expected = MissingMessageTarget::class)
    fun `sendePushNachrichtAnTopic erwartet  nichtleeres Topic`() =
        service.sendePushNachrichtAnTopic(notification = PushNotificationDto(channel = "Allgemein", collapseId = null), data = emptyMap(), topic = "")

    @Test
    fun `sendePushNachrichtAnTopic schickt eine Nachricht ab`() {
        service.sendePushNachrichtAnTopic(PushNotificationDto(channel = "Allgemein", collapseId = null), emptyMap(), "topic")

        verify(firebase, times(1)).send(any())
    }

    @Test
    fun `Firebase stubbed FirebaseMessaging wenn keine Konfigurationsdatei existiert`() {
        val firebase4real = Firebase()

        val message = mock<Message>()
        assertEquals(firebase4real.send(message), "")

        assertNull(firebase4real.sendMulticast(null))
    }
}