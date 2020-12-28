package de.kybernetik.rest

import com.google.gson.GsonBuilder
import com.google.gson.JsonSyntaxException
import de.kybernetik.database.pushmessages.PushMessage
import org.jboss.logging.Logger
import java.io.Serializable
import java.security.SecureRandom
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

private val LOG = Logger.getLogger(PushMessageDto::class.java)
private val GSON = GsonBuilder().serializeNulls().create()
private val KEY = SecretKeySpec(Base64.getDecoder().decode("vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc="), "AES")
private val secureRandom = SecureRandom()

data class PushMessageDto(
    var notification: PushNotificationDto? = null,
    var data: Map<String, Any?>? = null,
    var recipients: List<String>? = null
) {
    fun verschluesselt(): Map<String, String>? {
        try {
            // Parse Daten
            if (data == null) return null
            val json = GSON.toJson(data)
            val bytes = json.toByteArray()

            val nonce: String
            val ciphertext: String
            synchronized(Cipher::class.java) {
                val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
                cipher.init(Cipher.ENCRYPT_MODE, KEY, secureRandom)
                nonce = Base64.getEncoder().encodeToString(cipher.iv)
                val verschluesselt = cipher.doFinal(bytes)

                ciphertext = Base64.getEncoder().encodeToString(verschluesselt)
            }
            LOG.debug("Verschlüssele $data zu $ciphertext mit Nonce $nonce")
            return mapOf("encrypted" to "AES", "payload" to ciphertext, "nonce" to nonce)
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