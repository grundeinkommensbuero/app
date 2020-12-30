package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import de.kybernetik.database.pushmessages.PushMessage
import org.junit.Test
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
                PushNotificationDto("Titel", "Inhalt", "Allgemein")
            )
        )

        assertNull(dto.recipients)
        assertEquals(dto.data!!.size, 2)
        assertEquals(dto.data!!["key1"], "value1")
        assertEquals(dto.data!!["key2"], "value2")
        assertEquals(dto.notification!!.title, "Titel")
        assertEquals(dto.notification!!.body, "Inhalt")
    ***REMOVED***
***REMOVED***