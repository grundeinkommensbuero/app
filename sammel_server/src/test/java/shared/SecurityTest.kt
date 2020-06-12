package shared

import org.junit.Test

import org.junit.Assert.*
import shared.Security.HashMitSalt

class SecurityTest {

    @Test
    fun `hashSecret erzeugt unterschiedliche Hashes fuer unterschiedliche Secrets`() {
        val hashUndSalt1 = Security.hashSecret("secret1")
        val hashUndSalt2 = Security.hashSecret("secret2")

        assertFalse(hashUndSalt1.hash.equals(hashUndSalt2.hash))
    ***REMOVED***

    @Test
    fun `hashSecret erzeugt durch Salt unterschiedliche Hashes fuer gleiche Secrets`() {
        val hashUndSalt1 = Security.hashSecret("secret")
        val hashUndSalt2 = Security.hashSecret("secret")

        assertFalse(hashUndSalt1.hash.equals(hashUndSalt2.hash))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash erkennt korrekten Hash wieder`() {
        val hashUndSalt = Security.hashSecret("secret")

        assertTrue(Security.verifiziereSecretMitHash("secret", hashUndSalt))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash unterscheidet falschen Hash`() {
        val hashUndSalt = Security.hashSecret("secret")
        val falschesHashUndSalt = HashMitSalt(hashUndSalt.hash.substring(hashUndSalt.hash.length - 1) + "A", hashUndSalt.salt)

        assertFalse(Security.verifiziereSecretMitHash("secret", falschesHashUndSalt))
    ***REMOVED***

    @Test
    fun `verifiziereSecretMitHash unterscheidet bei abweichendem Salt`() {
        val hashUndSalt = Security.hashSecret("secret")
        val falschesHashUndSalt = HashMitSalt(hashUndSalt.hash, hashUndSalt.salt.substring(hashUndSalt.salt.length - 1) + "A")

        assertFalse(Security.verifiziereSecretMitHash("secret", falschesHashUndSalt))
    ***REMOVED***
***REMOVED***