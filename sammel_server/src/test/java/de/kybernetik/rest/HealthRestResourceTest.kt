package de.kybernetik.rest

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class HealthRestResourceTest {
    private val resource = HealthRestResource()

    @Test
    fun healthSendetLebenszeichen() {
        val response = resource.health()
        assertEquals(response.status ,200)
        val health = response.entity as Health
        assertEquals(health.status,"lebendig")
        assertTrue(health.version.isNotEmpty())
        assertEquals(health.minClient,"0.3.0+13")
    ***REMOVED***
***REMOVED***