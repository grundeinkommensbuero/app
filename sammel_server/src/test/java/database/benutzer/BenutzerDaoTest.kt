package database.benutzer

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import com.nhaarman.mockitokotlin2.*
import org.junit.Assert.assertFalse
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.*
import org.mockito.ArgumentMatchers.any
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import kotlin.test.assertSame
import kotlin.test.assertTrue
import database.benutzer.BenutzerDao as BenutzerDao

class BenutzerDaoTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<Benutzer>
    @Mock
    private lateinit var typedStringQuery: TypedQuery<String>

    @InjectMocks
    private lateinit var dao: BenutzerDao

    @Test
    fun `getBenutzer liefert Ergebnis aus DB`() {
        val karl = Benutzer(1L, "Karl Marx",0)
        whenever(entityManager.find(Benutzer::class.java, 1L))
                .thenReturn(karl)

        val ergebnis = dao.getBenutzer(1L)

        assertSame(ergebnis, karl)
    }

    @Test
    fun `benutzernameExistiert gibt true zurueck, wenn mindestens ein Benutzer mit dem Namen existiert`() {
        whenever(entityManager.createQuery(anyString(), any<Class<Benutzer>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter("name", "name"))
                .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
                .thenReturn(listOf(Benutzer()))

        val ergebnis = dao.benutzernameExistiert("name")

        assertTrue(ergebnis)
    }

    @Test
    fun `benutzernameExistiert gibt false zurueck, wenn kein Benutzer mit dem Namen existiert`() {
        whenever(entityManager.createQuery(anyString(), any<Class<Benutzer>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyOrNull()))
                .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
                .thenReturn(emptyList())

        val ergebnis = dao.benutzernameExistiert("name")

        assertFalse(ergebnis)
    }

    @Test
    fun `getFirebaseKeys reicht Liste von Keys weiter`() {
        val benutzer = listOf(karl(), rosa())
        whenever(entityManager.createQuery(anyString(), any<Class<String>>()))
                .thenReturn(typedStringQuery)
        whenever(typedStringQuery.setParameter(anyString(), anyList<String>()))
                .thenReturn(typedStringQuery)
        whenever(typedStringQuery.resultList)
                .thenReturn(listOf("key1", "key2"))

        val ergebnis: List<String> = dao.getFirebaseKeys(benutzer)

        val captor = argumentCaptor<List<Long>>()
        verify(typedStringQuery, times(1)).setParameter(anyString(), captor.capture())
        val argument = captor.firstValue
        assertTrue(argument.containsAll(benutzer.map { it.id }))
        assertTrue(ergebnis.containsAll(listOf("key1", "key2")))
    }

    @Test
    fun `getFirebaseKeys akzeptiert leeres Suchergebnis`() {
        val benutzer = emptyList<Benutzer>()
        whenever(entityManager.createQuery(anyString(), any<Class<String>>()))
                .thenReturn(typedStringQuery)
        whenever(typedStringQuery.setParameter(anyString(), anyList<String>()))
                .thenReturn(typedStringQuery)
        whenever(typedStringQuery.resultList)
                .thenReturn(emptyList())

        val ergebnis: List<String> = dao.getFirebaseKeys(benutzer)

        verify(typedStringQuery, times(1)).setParameter(anyString(), anyList<Long>())
        assertTrue(ergebnis.isEmpty())
    }

    @Test
    fun `legeNeueCredentialsAn reicht Credentials an Datenbank weiter`() {
        val credentials = Credentials()

        dao.legeNeueCredentialsAn(credentials)

        verify(entityManager, times(1)).persist(credentials)
    }
}
