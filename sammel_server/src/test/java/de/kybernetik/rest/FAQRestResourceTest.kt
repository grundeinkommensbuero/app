package de.kybernetik.rest

import com.nhaarman.mockitokotlin2.times
import com.nhaarman.mockitokotlin2.verify
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.faq.FAQBuilder
import de.kybernetik.database.faq.FAQDao
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import kotlin.test.assertEquals

class FAQRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: FAQDao

    @InjectMocks
    private lateinit var resource: FAQRestResource

    @Before
    fun setUp() {
        whenever(dao.getAllFAQ()).thenReturn(
            listOf(
                FAQBuilder().withGenericValues(1).build(),
                FAQBuilder().withGenericValues(2).build(),
                FAQBuilder().withGenericValues(3).build()
            )
        )
    ***REMOVED***

    @Test
    fun `getAllFAQs gibt Ergebnisse der Dao unveraendert als Dto weiter`() {
        val faqDtos = resource.getAllFAQs()

        verify(dao, times(1)).getAllFAQ()
        assertEquals(faqDtos.size, 3)
        assertEquals(faqDtos[0].titel, "Titel 1")
        assertEquals(faqDtos[0].teaser, "Teaser 1")
        assertEquals(faqDtos[0].rest, "Rest 1")
        assertEquals(faqDtos[0].order, 1.0)
        assertEquals(faqDtos[0].tags?.size, 1)
        assertEquals(faqDtos[0].tags!![0], "tag 1")

        assertEquals(faqDtos[1].titel, "Titel 2")
        assertEquals(faqDtos[1].teaser, "Teaser 2")
        assertEquals(faqDtos[1].rest, "Rest 2")
        assertEquals(faqDtos[1].order, 2.0)
        assertEquals(faqDtos[1].tags?.size, 2)
        assertEquals(faqDtos[1].tags!![0], "tag 1")
        assertEquals(faqDtos[1].tags!![1], "tag 2")

        assertEquals(faqDtos[2].titel, "Titel 3")
        assertEquals(faqDtos[2].teaser, "Teaser 3")
        assertEquals(faqDtos[2].rest, "Rest 3")
        assertEquals(faqDtos[2].order, 3.0)
        assertEquals(faqDtos[2].tags?.size, 3)
        assertEquals(faqDtos[2].tags!![0], "tag 1")
        assertEquals(faqDtos[2].tags!![1], "tag 2")
        assertEquals(faqDtos[2].tags!![2], "tag 3")
    ***REMOVED***
***REMOVED***