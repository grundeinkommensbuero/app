package shared

import org.apache.commons.codec.binary.Hex.*
import org.jboss.logging.Logger
import java.time.Instant.now
import java.time.temporal.ChronoUnit.MILLIS
import java.util.*
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec
import javax.ejb.Singleton
import kotlin.random.Random

@Singleton
open class Security {
    private val LOG = Logger.getLogger(Security::class.java)
    private val KEYFACTORY = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512")

    open fun hashSecret(secret: String): HashMitSalt {
        // Quelle: https://medium.com/@kasunpdh/how-to-store-passwords-securely-with-pbkdf2-204487f14e84
        val salt = Random.Default.nextBytes(512)
        val hash = hasheSecretMitSalt(secret, salt)

        return HashMitSalt(encodeHexString(hash), encodeHexString(salt))
    }

    private fun hasheSecretMitSalt(secret: String, salt: ByteArray): ByteArray {
        val startTime = now()
        val hash = KEYFACTORY.generateSecret(PBEKeySpec(secret.toCharArray(), salt, 10_000, 256)).getEncoded()
        LOG.info("Secret in ${startTime.until(now(), MILLIS)} Millisekunden gehasht mit Salt ${encodeHexString(salt)}")
        return hash
    }

    open fun verifiziereSecretMitHash(secret: String, hashMitSalt: HashMitSalt): Boolean {
        val hashAusSecret = hasheSecretMitSalt(secret, decodeHex(hashMitSalt.salt))
        val originalerHash = decodeHex(hashMitSalt.hash)

        return Arrays.equals(originalerHash, hashAusSecret)
    }

    data class HashMitSalt(
            val hash: String,
            val salt: String
    )
}