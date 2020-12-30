package de.kybernetik.services

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import com.google.gson.GsonBuilder
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessage
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.rest.PushMessageDto
import de.kybernetik.rest.PushNotificationDto
import org.junit.Before
import org.junit.Ignore
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

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
    ***REMOVED***

    @Test
    fun `sendePushNachrichtAnEmpfaenger ignoriert leere Anfragen`() {
        service.sendePushNachrichtAnEmpfaenger(PushMessageDto(), emptyList())

        verify(firebaseService, never()).sendePushNachrichtAnEmpfaenger(any(), any(), any())
        verify(pushDao, never()).speicherePushMessageFuerEmpfaenger(any(), any(), any())
    ***REMOVED***


    @Test
    fun `sendePushNachrichtAnEmpfaenger sendet an alle FirebaseKeys`() {
        val teilnehmerInnen = listOf(karl(), rosa())
        val firebaseKeys = listOf("key1", "key2")
        whenever(benutzerDao.getFirebaseKeys(teilnehmerInnen)).thenReturn(firebaseKeys)

        val notification = PushNotificationDto(channel = "Allgemein", collapseId = null)
        val data = PushMessageDto(notification)
        service.sendePushNachrichtAnEmpfaenger(data, teilnehmerInnen)

        verify(firebaseService, times(1))
                .sendePushNachrichtAnEmpfaenger(notification, emptyMap(), firebaseKeys)
    ***REMOVED***

    @Test
    fun `sendePushNachrichtAnEmpfaenger sendet nichts an Firebase ohne FirebaseKeys`() {
        val teilnehmer = listOf(karl(), rosa())
        whenever(benutzerDao.getFirebaseKeys(teilnehmer)).thenReturn(emptyList())

        service.sendePushNachrichtAnEmpfaenger(PushMessageDto(PushNotificationDto(
            channel = "Allgemein",
            collapseId = null
        )), teilnehmer)

        verify(firebaseService, never()).sendePushNachrichtAnEmpfaenger(any(), any(), any())
    ***REMOVED***

    @Test
    fun `sendePushNachrichtAnEmpfaenger speichert PushMessage fuer alle Nicht-Firebase-User`() {
        val teilnehmerInnen = listOf(karl(), rosa())
        whenever(benutzerDao.getBenutzerOhneFirebase(teilnehmerInnen)).thenReturn(teilnehmerInnen)

        val notification = PushNotificationDto(channel = "Allgemein", collapseId = null)
        service.sendePushNachrichtAnEmpfaenger(PushMessageDto(notification), teilnehmerInnen)

        val notificationCaptor = argumentCaptor<PushNotificationDto>()
        val teilnehmerCaptor = argumentCaptor<List<Benutzer>>()
        val dataCaptor = argumentCaptor<Map<String, String>>()
        verify(pushDao, times(1))
                .speicherePushMessageFuerEmpfaenger(notificationCaptor.capture(), dataCaptor.capture(), teilnehmerCaptor.capture())
        assertEquals(notification, notificationCaptor.firstValue)
        assertTrue(dataCaptor.firstValue.isEmpty())
        assertEquals(teilnehmerInnen, teilnehmerCaptor.firstValue)
    ***REMOVED***

    @Test
    fun `sendePushNachrichtAnEmpfaenger speichert keine PushMessage ohne Nicht-Firebase-User`() {
        val teilnehmer = listOf(karl(), rosa())
        whenever(benutzerDao.getBenutzerOhneFirebase(teilnehmer)).thenReturn(emptyList())

        service.sendePushNachrichtAnEmpfaenger(PushMessageDto(PushNotificationDto(
            channel = "Allgemein",
            collapseId = null
        )), teilnehmer)

        verify(pushDao, never()).speicherePushMessageFuerEmpfaenger(any(), any(), any())
    ***REMOVED***

    @Test
    fun `verschluesselt() reicht verschluesselte Daten heraus`() {
        val dto = PushMessageDto.convertFromPushMessage(
            PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto("Titel", "Inhalt", "Allgemein", null)
            )
        )

        val nachricht = service.verschluessele(dto.data)!!
        val ciphertext = nachricht["payload"]!!
        assertFalse(ciphertext.contains("key1"))
        assertFalse(ciphertext.contains("value1"))
        assertFalse(ciphertext.contains("key2"))
        assertFalse(ciphertext.contains("value2"))

        val plaintext = entschluessele(nachricht)

        println("Paintext: $plaintext")

        val data = GsonBuilder().serializeNulls().create().fromJson(plaintext, Map::class.java)
        assertEquals(data["key1"], "value1")
        assertEquals(data["key2"], "value2")
    ***REMOVED***

    @Test
    fun `verschluesselt() notiert Verschluesselungstyp und Nonce`() {
        val dto = PushMessageDto.convertFromPushMessage(
            PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto("Titel", "Inhalt", "Allgemein", null)
            )
        )

        val nachricht = service.verschluessele(dto.data)!!
        assertEquals(nachricht["encrypted"], "AES")
        assertNotNull(nachricht["nonce"])
    ***REMOVED***

    @Ignore("Zum manuellen Testen Log-Level in Funktion auf info stellen")
    @Test
    fun verschluessele() {
        service.verschluessele(mapOf("content" to "Hello World"))
    ***REMOVED***

    companion object {
        fun entschluessele(data: Map<String, String>): String {
            val nonce = data["nonce"] as String
            val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
            cipher.init(
                Cipher.DECRYPT_MODE,
                SecretKeySpec(Base64.getDecoder().decode("vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc="), "AES"),
                IvParameterSpec(Base64.getDecoder().decode(nonce))
            )
            val plainbytes = cipher.doFinal(Base64.getDecoder().decode(data["payload"]))
            return String(plainbytes, Charsets.UTF_8)
        ***REMOVED***
    ***REMOVED***
***REMOVED***