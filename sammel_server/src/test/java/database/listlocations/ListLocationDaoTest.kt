package database.listlocations

import TestdatenVorrat.Companion.cafeKotti
import TestdatenVorrat.Companion.curry36
import TestdatenVorrat.Companion.sampleListLocations
import TestdatenVorrat.Companion.zukunft
import com.nhaarman.mockitokotlin2.anyOrNull
import com.nhaarman.mockitokotlin2.whenever
import org.junit.Test

import org.junit.Rule
import org.mockito.ArgumentMatchers.*
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import kotlin.test.assertEquals
import kotlin.test.assertSame

class ListLocationDaoTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<ListLocation>

    @InjectMocks
    private lateinit var dao: ListLocationDao

    @Test
    fun getActiveListLocationsReturnsFoundListlocationsUnchanged() {
        val response = sampleListLocations()
        whenever(entityManager.createQuery(anyString(), any<Class<ListLocation>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyOrNull()))
                .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
                .thenReturn(response)

        val ergebnis = dao.getActiveListLocations()!!

        assertSame(ergebnis.size, 3)

        assertEquals(ergebnis[0].id, curry36().id)
        assertEquals(ergebnis[0].name, curry36().name)
        assertEquals(ergebnis[0].strasse, curry36().strasse)
        assertEquals(ergebnis[0].nummer, curry36().nummer)
        assertEquals(ergebnis[0].latitude, curry36().latitude)
        assertEquals(ergebnis[0].longitude, curry36().longitude)

        assertEquals(ergebnis[1].id, cafeKotti().id)
        assertEquals(ergebnis[1].name, cafeKotti().name)
        assertEquals(ergebnis[1].strasse, cafeKotti().strasse)
        assertEquals(ergebnis[1].nummer, cafeKotti().nummer)
        assertEquals(ergebnis[1].latitude, cafeKotti().latitude)
        assertEquals(ergebnis[1].longitude, cafeKotti().longitude)

        assertEquals(ergebnis[2].id, zukunft().id)
        assertEquals(ergebnis[2].name, zukunft().name)
        assertEquals(ergebnis[2].strasse, zukunft().strasse)
        assertEquals(ergebnis[2].nummer, zukunft().nummer)
        assertEquals(ergebnis[2].latitude, zukunft().latitude)
        assertEquals(ergebnis[2].longitude, zukunft().longitude)
    ***REMOVED***
***REMOVED***