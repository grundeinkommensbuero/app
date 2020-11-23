package de.kybernetik.database.pushmessages

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.rest.PushMessageDto
import org.junit.Test

import org.junit.Assert.*
import org.junit.Before
import org.junit.Rule
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.PushNotificationDto
import org.mockito.ArgumentMatchers.anyDouble
import javax.persistence.EntityManager
import javax.persistence.TypedQuery

class PushMessageDaoTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entity: EntityManager

    @Mock
    private lateinit var typedQuery: TypedQuery<PushMessage>

    @InjectMocks
    private lateinit var dao: PushMessageDao

    @Before
    fun setUp() {
        whenever(entity.createQuery(anyString(), any<Class<PushMessage>>()))
                .thenReturn(typedQuery)
    ***REMOVED***

    @Test
    fun `ladeAllePushMessagesFuerBenutzer sucht nach Benutzer-ID`() {
        val pushMessages = listOf(PushMessage(karl(), emptyMap(), PushNotificationDto()))

        whenever(typedQuery.resultList).thenReturn(pushMessages)

        val ergebnis = dao.ladeAllePushMessagesFuerBenutzer(11L)

        verify(entity, times(1)).createQuery("select m from PushMessages m where m.empfaenger = 11", PushMessage::class.java)
        assertEquals(ergebnis, pushMessages)
    ***REMOVED***

    @Test
    fun `speicherePushMessage legt PushMessage fuer jeden Empfaenger ab`() {
        val pushMessage = PushMessageDto(PushNotificationDto(), mapOf("key" to "value"))

        dao.speicherePushMessageFuerEmpfaenger(pushMessage, listOf(karl(), rosa()))

        val captor = argumentCaptor<PushMessage>()
        verify(entity, times(2)).persist(captor.capture())

        assertEquals(captor.firstValue.empfaenger.id, karl().id)
        assertEquals(captor.secondValue.empfaenger.id, rosa().id)
    ***REMOVED***

    @Test
    fun `speicherePushMessage kommt mit leerer Empfaengerliste klar`() {
        val pushMessage = PushMessageDto(PushNotificationDto(), mapOf("key" to "value"))

        dao.speicherePushMessageFuerEmpfaenger(pushMessage, emptyList())

        verify(entity, never()).persist(any())                                                   
    ***REMOVED***

    @Test
    fun `loeschePushMessages loescht Nachrichten in DB`() {
        val pushMessages = listOf(
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto()),
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto()),
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto()))

        dao.loeschePushMessages(pushMessages)

        verify(entity, times(3)).find(PushMessage::class.java, 0L)
        verify(entity, times(3)).remove(null)
    ***REMOVED***

    @Test
    fun `loeschePushMessages kommt mit leerer Liste klar`() {
        dao.loeschePushMessages(emptyList())
    ***REMOVED***
***REMOVED***