package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import com.google.gson.GsonBuilder
import de.kybernetik.database.pushmessages.PushMessage
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals
import kotlin.test.assertNull

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

        val payload = dto.verschluesselt()!!["payload"]
        assertEquals(payload, "eyJrZXkxIjoidmFsdWUxIiwia2V5MiI6InZhbHVlMiJ9")
        val bytes: ByteArray = Base64.getDecoder().decode(payload)!!
        val json: String = bytes.decodeToString()

        @Suppress("UNCHECKED_CAST")
        val data = GsonBuilder().serializeNulls().create().fromJson(json, Map::class.java)
        assertEquals(data["key1"], "value1")
        assertEquals(data["key2"], "value2")
    ***REMOVED***

    @Test
    fun `verschluesselt() notiert Verschluesselungstyp`() {
        val dto = PushMessageDto.convertFromPushMessage(
            PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto("Titel", "Inhalt")
            )
        )

        assertEquals(dto.verschluesselt()!!["encrypted"], "Base64")
    ***REMOVED***
***REMOVED***