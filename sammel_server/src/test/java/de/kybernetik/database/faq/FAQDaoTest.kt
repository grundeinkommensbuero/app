package de.kybernetik.database.faq

import com.nhaarman.mockitokotlin2.times
import com.nhaarman.mockitokotlin2.verify
import com.nhaarman.mockitokotlin2.whenever
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.time.LocalDateTime
import javax.persistence.EntityManager
import javax.persistence.NoResultException
import javax.persistence.TypedQuery
import kotlin.test.assertEquals

class FAQDaoTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager

    @Mock
    private lateinit var typedQuery: TypedQuery<FAQ>

    @Mock
    private lateinit var typedQueryTimestamp: TypedQuery<FAQTimestamp>

    @InjectMocks
    private lateinit var dao: FAQDao

    private lateinit var response: List<FAQ>

    @Before
    fun setUp() {
        response = listOf(
            FAQBuilder().withGenericValues(1).build(),
            FAQBuilder().withGenericValues(2).build(),
            FAQBuilder().withGenericValues(3).build()
        )

        whenever(entityManager.createQuery(ArgumentMatchers.anyString(), ArgumentMatchers.any<Class<FAQ>>()))
            .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
            .thenReturn(response)
    ***REMOVED***

    @Test
    fun `getAllFAQ fragt Datenbank und reicht Amtwort weiter`() {
        val faqs = dao.getAllFAQ()

        assertEquals(faqs.size, 3)
        assertEquals(faqs[0], response[0])
        assertEquals(faqs[1], response[1])
        assertEquals(faqs[2], response[2])

        verify(entityManager, times(1)).createQuery("from FAQ", FAQ::class.java)
    ***REMOVED***

    @Test
    fun `getFAQTimestamp returns existing timestamp`() {
        val faqTimestamp = FAQTimestamp()
        faqTimestamp.timestamp = LocalDateTime.of(2021, 4, 12, 16, 35, 0)
        whenever(entityManager.createQuery(ArgumentMatchers.anyString(), ArgumentMatchers.any<Class<FAQTimestamp>>()))
            .thenReturn(typedQueryTimestamp)
        whenever(typedQueryTimestamp.singleResult)
            .thenReturn(faqTimestamp)

        assertEquals(dao.getFAQTimestamp(), faqTimestamp.timestamp)
    ***REMOVED***

    @Test
    fun `getFAQTimestamp returns null on missing timestamp`() {
        whenever(entityManager.createQuery(ArgumentMatchers.anyString(), ArgumentMatchers.any<Class<FAQTimestamp>>()))
            .thenReturn(typedQueryTimestamp)
        whenever(typedQueryTimestamp.singleResult)
            .thenThrow(NoResultException::class.java)

        assertEquals(dao.getFAQTimestamp(), null)
    ***REMOVED***
***REMOVED***

@Suppress("unused")
open class FAQBuilder {
    var faq = FAQ()

    open fun withId(id: Long): FAQBuilder {
        faq.id = id
        return this
    ***REMOVED***

    open fun withTitel(titel: String): FAQBuilder {
        faq.titel = titel
        return this
    ***REMOVED***

    open fun withTeaser(teaser: String): FAQBuilder {
        faq.teaser = teaser
        return this
    ***REMOVED***

    fun withRest(rest: String): FAQBuilder {
        faq.rest = rest
        return this
    ***REMOVED***

    open fun withOrder(order: Double): FAQBuilder {
        faq.order = order
        return this
    ***REMOVED***

    open fun withTags(tags: List<String>): FAQBuilder {
        faq.tags = tags
        return this
    ***REMOVED***

    open fun withGenericValues(offset: Long): FAQBuilder {
        faq.id = offset
        faq.titel = "Titel ${offset***REMOVED***"
        faq.teaser = "Teaser ${offset***REMOVED***"
        faq.rest = "Rest ${offset***REMOVED***"
        faq.order = offset.toDouble()
        faq.tags = (1.rangeTo(offset)).map { "tag $it" ***REMOVED***
        return this
    ***REMOVED***

    open fun build(): FAQ = faq
***REMOVED***