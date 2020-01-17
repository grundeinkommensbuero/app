package database.stammdaten

import com.nhaarman.mockitokotlin2.any
import com.nhaarman.mockitokotlin2.whenever
import org.junit.Test

import org.junit.Rule
import org.mockito.ArgumentMatchers
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.StammdatenRestResource
import javax.persistence.EntityManager
import javax.persistence.TypedQuery

class StammdatenDaoTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<Ort>

    @InjectMocks
    private lateinit var dao: StammdatenDao

    @Test
    fun getOrteLiefertOrteAusDb() {
        val orteAusDb = listOf(Ort(1, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez"))
        whenever(entityManager.createQuery(ArgumentMatchers.anyString(), any<Class<Ort>>())).thenReturn(typedQuery)
        whenever(typedQuery.resultList).thenReturn(orteAusDb)

        val orte = dao.getOrte()

        assert(orte.containsAll(orteAusDb))
    ***REMOVED***

    companion object {
        fun nordkiez(): StammdatenRestResource.OrtDto =
                StammdatenRestResource.OrtDto(0, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez")
    ***REMOVED***

***REMOVED***