package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import com.google.gson.GsonBuilder
import de.kybernetik.database.pushmessages.PushMessage
import org.junit.Ignore
import org.junit.Test
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotNull
import kotlin.test.assertNull
import kotlin.text.Charsets.UTF_8

@ExperimentalStdlibApi
class PushMessageDtoTest {

    @Test
    fun `erzeugt aus PushMessage PushMessageDto ohne Empfaenger`() {
        val dto = PushMessageDto.convertFromPushMessage(
            PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto("Titel", "Inhalt")
            )
        )

        assertNull(dto.recipients)
        assertEquals(dto.data!!.size, 2)
        assertEquals(dto.data!!["key1"], "value1")
        assertEquals(dto.data!!["key2"], "value2")
        assertEquals(dto.notification!!.title, "Titel")
        assertEquals(dto.notification!!.body, "Inhalt")
    ***REMOVED***

    @Test
    fun `verschluesselt() reicht verschluesselte Daten heraus`() {
        val dto = PushMessageDto.convertFromPushMessage(
            PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto("Titel", "Inhalt")
            )
        )

        val nachricht = dto.verschluesselt()!!
        val ciphertext = nachricht["payload"]!!
        assertFalse(ciphertext.contains("key1"))
        assertFalse(ciphertext.contains("value1"))
        assertFalse(ciphertext.contains("key2"))
        assertFalse(ciphertext.contains("value2"))

        val plaintext = entschluessele(nachricht)

        @Suppress("UNCHECKED_CAST")
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
                PushNotificationDto("Titel", "Inhalt")
            )
        )

        val nachricht = dto.verschluesselt()!!
        assertEquals(nachricht["encrypted"], "AES")
        assertNotNull(nachricht["nonce"])
    ***REMOVED***

    @Ignore("Zum manuellen Testen Log-Level in Funktion auf info stellen")
    @Test
    fun verschluessele() {
        PushMessageDto(null, mapOf("content" to "Hello World")).verschluesselt()
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
            return String(plainbytes, UTF_8)
        ***REMOVED***
    ***REMOVED***
***REMOVED***