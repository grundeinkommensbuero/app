package services

import com.google.firebase.messaging.BatchResponse
import com.google.firebase.messaging.FirebaseMessaging
import com.nhaarman.mockitokotlin2.*
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.PushNotificationDto
import services.FirebaseService.MissingMessageTarget

class FirebaseServiceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var firebase: Firebase

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
***REMOVED***