package de.kybernetik.shared

import org.apache.commons.codec.DecoderException
import org.apache.commons.codec.binary.Hex.decodeHex
import org.apache.commons.codec.binary.Hex.encodeHexString
import org.jboss.logging.Logger
import org.wildfly.security.WildFlyElytronProvider
import org.wildfly.security.password.PasswordFactory
import org.wildfly.security.password.interfaces.BCryptPassword
import org.wildfly.security.password.spec.EncryptablePasswordSpec
import org.wildfly.security.password.spec.SaltedPasswordAlgorithmSpec
import java.security.Provider
import java.security.SecureRandom
import java.time.Instant.now
import java.time.temporal.ChronoUnit.MILLIS
import java.util.*
import javax.ejb.Stateless


@Stateless
open class Security {
    private val LOG = Logger.getLogger(Security::class.java)
    private val ELYTRON_PROVIDER: Provider = WildFlyElytronProvider()
    private val BCRYPTFACTORY = PasswordFactory.getInstance(BCryptPassword.ALGORITHM_BCRYPT, ELYTRON_PROVIDER)

    open fun hashSecret(secret: String): HashMitSalt {
        // Quelle: Siehe "Using a Hashed Password Representation" in https://docs.wildfly.org/17/WildFly_Elytron_Security.html
        val salt = ByteArray(16)
        SecureRandom().nextBytes(salt)
        val hash = hasheSecretMitSalt(secret, salt)

        return HashMitSalt(encodeHexString(hash), encodeHexString(salt))
    }

    private fun hasheSecretMitSalt(secret: String, salt: ByteArray): ByteArray {
        val startTime = now()
        val encryptableSpec = EncryptablePasswordSpec(secret.toCharArray(), SaltedPasswordAlgorithmSpec(salt))
        val password = BCRYPTFACTORY.generatePassword(encryptableSpec) as BCryptPassword
        LOG.trace("Secret in ${startTime.until(now(), MILLIS)} Millisekunden gehasht mit Salt ${encodeHexString(salt)}")
        return password.hash
    }

    @Throws(DecoderException::class)
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