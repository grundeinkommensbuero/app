package de.kybernetik.services

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.rest.PushNotificationDto
import org.junit.Before
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import kotlin.test.assertEquals

class PushServiceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var firebaseService: FirebaseService

    @Mock
    private lateinit var benutzerDao: BenutzerDao

    @Mock
    private lateinit var pushDao: PushMessageDao

    @InjectMocks
    private val service = PushService()

    @Before
    fun setUp() {
        whenever(benutzerDao.getFirebaseKeys(any())).thenReturn(emptyList())
        whenever(benutzerDao.getBenutzerOhneFirebase(any())).thenReturn(emptyList())
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger ignoriert leere Anfragen`() {
        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(), emptyMap(), emptyList())

        verify(firebaseService, never()).sendePushNachrichtAnEmpfaenger(any(), any(), any())
        verify(pushDao, never()).speicherePushMessageFuerEmpfaenger(any(), any(), any())
    }


    @Test
    fun `sendePushNachrichtAnEmpfaenger sendet an alle FirebaseKeys`() {
        val teilnehmerInnen = listOf(karl(), rosa())
        val firebaseKeys = listOf("key1", "key2")
        whenever(benutzerDao.getFirebaseKeys(teilnehmerInnen)).thenReturn(firebaseKeys)

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        service.sendePushNachrichtAnEmpfaenger(notification, data, teilnehmerInnen)

        verify(firebaseService, times(1))
                .sendePushNachrichtAnEmpfaenger(notification, data, firebaseKeys)
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger sendet nichts an Firebase ohne FirebaseKeys`() {
        val teilnehmer = listOf(karl(), rosa())
        whenever(benutzerDao.getFirebaseKeys(teilnehmer)).thenReturn(emptyList())

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(), emptyMap(), teilnehmer)

        verify(firebaseService, never()).sendePushNachrichtAnEmpfaenger(any(), any(), any())
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger speichert PushMessage fuer alle Nicht-Firebase-User`() {
        val teilnehmerInnen = listOf(karl(), rosa())
        whenever(benutzerDao.getBenutzerOhneFirebase(teilnehmerInnen)).thenReturn(teilnehmerInnen)

        val notification = PushNotificationDto()
        val data = emptyMap<String, String>()
        service.sendePushNachrichtAnEmpfaenger(notification, data, teilnehmerInnen)

        val notificationCaptor = argumentCaptor<PushNotificationDto>()
        val teilnehmerCaptor = argumentCaptor<List<Benutzer>>()
        val dataCaptor = argumentCaptor<Map<String, String>>()
        verify(pushDao, times(1))
                .speicherePushMessageFuerEmpfaenger(notificationCaptor.capture(), dataCaptor.capture(), teilnehmerCaptor.capture())
        assertEquals(notification, notificationCaptor.firstValue)
        assertEquals(data, dataCaptor.firstValue)
        assertEquals(teilnehmerInnen, teilnehmerCaptor.firstValue)
    }

    @Test
    fun `sendePushNachrichtAnEmpfaenger speichert keine PushMessage ohne Nicht-Firebase-User`() {
        val teilnehmer = listOf(karl(), rosa())
        whenever(benutzerDao.getBenutzerOhneFirebase(teilnehmer)).thenReturn(emptyList())

        service.sendePushNachrichtAnEmpfaenger(PushNotificationDto(), emptyMap(), teilnehmer)

        verify(pushDao, never()).speicherePushMessageFuerEmpfaenger(any(), any(), any())
    }
}