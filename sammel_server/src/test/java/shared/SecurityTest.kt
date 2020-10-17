package shared

import org.apache.commons.codec.binary.Hex
import org.junit.Test

import org.junit.Assert.*
import org.junit.Ignore
import shared.Security.HashMitSalt
import java.security.SecureRandom
import java.util.*

class SecurityTest {

    val security = Security()

    @Test
    fun `hashSecret erzeugt unterschiedliche Hashes fuer unterschiedliche Secrets`() {
        val hashUndSalt1 = security.hashSecret("secret1")
        val hashUndSalt2 = security.hashSecret("secret2")

        assertFalse(hashUndSalt1.hash.equals(hashUndSalt2.hash))
    ***REMOVED***

    @Test
    fun `hashSecret erzeugt durch Salt unterschiedliche Hashes fuer gleiche Secrets`() {
        val hashUndSalt1 = security.hashSecret("secret")
        val hashUndSalt2 = security.hashSecret("secret")

        assertFalse(hashUndSalt1.hash.equals(hashUndSalt2.hash))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash erkennt korrekten Hash wieder`() {
        val hashUndSalt = security.hashSecret("secret")

        assertTrue(security.verifiziereSecretMitHash("secret", hashUndSalt))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash unterscheidet falschen Hash`() {
        val hashUndSalt = security.hashSecret("secret")
        val falschesHashUndSalt = HashMitSalt(hashUndSalt.hash.substring(hashUndSalt.hash.length - 1) + "A", hashUndSalt.salt)

        assertFalse(security.verifiziereSecretMitHash("secret", falschesHashUndSalt))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash unterscheidet bei abweichendem Salt`() {
        val hashUndSalt = security.hashSecret("secret")
        val falschesSalt = ByteArray(16)
        SecureRandom().nextBytes(falschesSalt)
        val falschesHashUndSalt = HashMitSalt(hashUndSalt.hash, Hex.encodeHexString(falschesSalt))

        assertFalse(security.verifiziereSecretMitHash("secret", falschesHashUndSalt))
    ***REMOVED***

    @Ignore("Zum Erzeugen von Drittsystem-Secrets")
    @Test
    fun `erzeuge Hash und Salt`() {
        val secret = UUID.randomUUID().toString()

        val hashMitSalt = security.hashSecret(secret)

        println("secret: $secret")
        println("hash: ${hashMitSalt.hash***REMOVED***")
        println("salt: ${hashMitSalt.salt***REMOVED***")
    ***REMOVED***

    @Ignore("Zum Erzeugen von BASE64-codierter Basic-Auth")
    @Test
    fun test() {
        val base64 = Base64.getEncoder().encodeToString("<secret>".toByteArray())

        println(base64)
    ***REMOVED***
***REMOVED***