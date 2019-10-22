package database.benutzer

import com.nhaarman.mockitokotlin2.anyOrNull
import com.nhaarman.mockitokotlin2.whenever
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.*
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import kotlin.test.assertFailsWith
import kotlin.test.assertNull
import kotlin.test.assertSame
import database.benutzer.BenutzerDao as BenutzerDao

class BenutzerDaoTest {

    @Rule
    @JvmField
    var mockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<Benutzer>

    @InjectMocks
    private lateinit var dao: BenutzerDao;

    @Test
    fun getBenutzerLiefertFehlermeldungBeiMultiplenErgebnissen() {
        val response = listOf(
                Benutzer(1, "Karl Marx", "hash1", ""),
                Benutzer(3, "Karl Marx", "hash2", "")
        )
        whenever(entityManager.createQuery(anyString(), any<Class<Benutzer>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyString()))
                .thenReturn(typedQuery)
        whenever(typedQuery.getResultList())
                .thenReturn(response)

        assertFailsWith<BenutzerDao.BenutzerMehrfachVorhandenException> {
            dao.getBenutzer("Karl Marx")
        ***REMOVED***
    ***REMOVED***

    @Test
    fun getBenutzerLiefertNullBeiKeinenErgebnissen() {
        val response = emptyList<Benutzer>()
        whenever(entityManager.createQuery(anyString(), any<Class<Benutzer>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyOrNull()))
                .thenReturn(typedQuery)
        whenever(typedQuery.getResultList())
                .thenReturn(response)

        assertNull(dao.getBenutzer("Antonio Gramsci"))
    ***REMOVED***

    @Test
    fun getBenutzerLiefertBenutzerBeiEinzelnemErgebnis() {
        val karl = Benutzer(1, "Karl Marx", "hash1", "")
        val response = listOf(karl)
        whenever(entityManager.createQuery(anyString(), any<Class<Benutzer>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyOrNull()))
                .thenReturn(typedQuery)
        whenever(typedQuery.getResultList())
                .thenReturn(response)

        val ergebnis = dao.getBenutzer("Karl Marx")

        assertSame(ergebnis, karl)
    ***REMOVED***
***REMOVED***
