package de.kybernetik.rest

import org.junit.Before
import org.junit.Test
import java.lang.System.setProperty
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class HealthRestResourceTest {
    private val resource = HealthRestResource()

    @Before
    fun setUp() {
        setProperty("mode", "LOCAL")
    }

    @Test
    fun healthSendetLebenszeichen() {
        val response = resource.health()
        assertEquals(response.status ,200)
        val health = response.entity as Health
        assertEquals(health.status,"lebendig")
        assertTrue(health.version.isNotEmpty())
        assertTrue(health.minClient.isNotEmpty())
        assertEquals("LOCAL", health.modus)
    }
}