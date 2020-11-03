package de.kybernetik.database.pushmessages

import TestdatenVorrat.Companion.karl
import org.junit.Assert.*
import org.junit.Test
import de.kybernetik.rest.PushNotificationDto

class PushMessageTest {
    @Test
    fun `kann mit null umgehen`() {
        val pushMessage = PushMessage(karl(), null, null)

        assertNull(pushMessage.benachrichtigung)
        assertNull(pushMessage.daten)
    ***REMOVED***

    @Test
    fun `serialisiert und deserialisiert korrekt`() {
        val pushMessage = PushMessage(
                karl(),
                mapOf("key1" to "value1", "key2" to "value2"),
                PushNotificationDto(title = "Titel", body = "Inhalt"))

        assertEquals(pushMessage.getDaten()!!.size, 2)
        assertEquals(pushMessage.getDaten()!!["key1"], "value1")
        assertEquals(pushMessage.getDaten()!!["key2"], "value2")
        assertEquals(pushMessage.getBenachrichtigung()!!.title, "Titel")
        assertEquals(pushMessage.getBenachrichtigung()!!.body, "Inhalt")
    ***REMOVED***
***REMOVED***