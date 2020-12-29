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
    }
}