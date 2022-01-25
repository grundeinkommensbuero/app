package de.kybernetik.rest

import com.nhaarman.mockitokotlin2.isNull
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.faq.FAQDao
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.lang.System.setProperty
import java.time.LocalDateTime
import java.time.Month
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class HealthRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var faqDao: FAQDao

    @InjectMocks
    lateinit var resource: HealthRestResource

    val faqTimestamp = LocalDateTime.of(2021, Month.APRIL, 12, 17, 45)

    @Before
    fun setUp() {
        setProperty("mode", "LOCAL")
        whenever(faqDao.getFAQTimestamp()).thenReturn(faqTimestamp)
    }

    @Test
    fun healthSendetLebenszeichen() {
        val response = resource.health()
        assertEquals(response.status, 200)
        val health = response.entity as Health
        assertEquals(health.status, "lebendig")
        assertTrue(health.version.isNotEmpty())
        assertTrue(health.minClient.isNotEmpty())
        assertEquals("LOCAL", health.modus)
        assertEquals(faqTimestamp, health.faqTimestamp)
    }

    @Test
    fun healthAcceptsNullTimestamp() {
        whenever(faqDao.getFAQTimestamp()).thenReturn(null)
        val response = resource.health()
        assertEquals(response.status, 200)
        val health = response.entity as Health
        assertEquals(health.status, "lebendig")
        assertTrue(health.version.isNotEmpty())
        assertTrue(health.minClient.isNotEmpty())
        assertEquals("LOCAL", health.modus)
        assertNull(health.faqTimestamp)
    }
}