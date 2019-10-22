package rest

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.expect

class HealthRestResourceTest {
    private val resource = HealthRestResource()

    @Test
    fun healthSendetLebenszeichen() {
        val response = resource.health()
        assertEquals(response.status ,200)
        val health = response.entity as Health
        assertEquals(health.status,"lebendig")
        assertEquals(health.version,"Alpha-1.0")
    ***REMOVED***
***REMOVED***