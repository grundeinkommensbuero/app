package de.kybernetik.rest

import com.google.gson.GsonBuilder
import com.google.gson.JsonSyntaxException
import de.kybernetik.database.pushmessages.PushMessage
import org.jboss.logging.Logger
import java.io.Serializable
import java.util.*

private val LOG = Logger.getLogger(PushMessageDto::class.java)
private val GSON = GsonBuilder().serializeNulls().create()

data class PushMessageDto(
    var notification: PushNotificationDto? = null,
    var data: Map<String, Any?>? = null,
    var recipients: List<String>? = null
) {
    fun verschluesselt(): Map<String, String>? {
        try {
            if (data == null) return null
            val json = GSON.toJson(data)
            val bytes = json.toByteArray()
            val base64 = Base64.getEncoder().encodeToString(bytes)
            LOG.debug("Verschlüssele $data zu $base64")
            return mapOf("encrypted" to "Base64", "payload" to base64)
        } catch (e: JsonSyntaxException) {
            LOG.error("Serialisieren von Push-Nachricht gescheitert", e)
            return null
        }
    }

    companion object {
        fun convertFromPushMessage(pushMessage: PushMessage): PushMessageDto =
            PushMessageDto(pushMessage.getBenachrichtigung(), pushMessage.getDaten(), null)
    }
}

data class PushNotificationDto(
    var title: String? = null,
    var body: String? = null
) : Serializable

