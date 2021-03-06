package de.kybernetik.database.pushmessages

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import com.nhaarman.mockitokotlin2.*
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
    }

    @Test
    fun `ladeAllePushMessagesFuerBenutzer sucht nach Benutzer-ID`() {
        val pushMessages = listOf(PushMessage(karl(), emptyMap(), PushNotificationDto(
            channel = "Allgemein",
            collapseId = null
        )))

        whenever(typedQuery.resultList).thenReturn(pushMessages)

        val ergebnis = dao.ladeAllePushMessagesFuerBenutzer(11L)

        verify(entity, times(1)).createQuery("select m from PushMessages m where m.empfaenger = 11", PushMessage::class.java)
        assertEquals(ergebnis, pushMessages)
    }

    @Test
    fun `speicherePushMessage legt PushMessage fuer jeden Empfaenger ab`() {
        dao.speicherePushMessageFuerEmpfaenger(PushNotificationDto(channel = "Allgemein", collapseId = null), mapOf("key" to "value"), listOf(karl(), rosa()))

        val captor = argumentCaptor<PushMessage>()
        verify(entity, times(2)).persist(captor.capture())

        assertEquals(captor.firstValue.empfaenger.id, karl().id)
        assertEquals(captor.secondValue.empfaenger.id, rosa().id)
    }

    @Test
    fun `speicherePushMessage kommt mit leerer Empfaengerliste klar`() {
        dao.speicherePushMessageFuerEmpfaenger(PushNotificationDto(channel = "Allgemein", collapseId = null), mapOf("key" to "value"), emptyList())

        verify(entity, never()).persist(any())                                                   
    }

    @Test
    fun `loeschePushMessages loescht Nachrichten in DB`() {
        val pushMessages = listOf(
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto(
                    channel = "Allgemein",
                    collapseId = null
                )),
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto(
                    channel = "Allgemein",
                    collapseId = null
                )),
                PushMessage(karl(), mapOf("key" to "value"), PushNotificationDto(
                    channel = "Allgemein",
                    collapseId = null
                )))

        dao.loeschePushMessages(pushMessages)

        verify(entity, times(3)).find(PushMessage::class.java, 0L)
        verify(entity, times(3)).remove(null)
    }

    @Test
    fun `loeschePushMessages kommt mit leerer Liste klar`() {
        dao.loeschePushMessages(emptyList())
    }
}