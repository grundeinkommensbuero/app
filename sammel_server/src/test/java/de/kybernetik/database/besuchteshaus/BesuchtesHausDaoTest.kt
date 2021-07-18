package de.kybernetik.database.besuchteshaus

import TestdatenVorrat.Companion.hausundgrund
import org.junit.Test

import org.junit.Assert.*
import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import TestdatenVorrat.Companion.kanzlerinamt
import TestdatenVorrat.Companion.konradadenauerhaus
import com.nhaarman.mockitokotlin2.*
import org.mockito.ArgumentMatchers.anyString
import java.lang.IllegalArgumentException

class BesuchtesHausDaoTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<BesuchtesHaus>

    @InjectMocks
    private lateinit var besuchtesHausDao: BesuchtesHausDao

    @Test
    fun erstelleBesuchtesHausPersistiertNeuesBesuchtesHaus() {
        val besuchtesHaus = kanzlerinamt()
        besuchtesHausDao.erstelleBesuchtesHaus(besuchtesHaus)

        verify(entityManager, times(1)).persist(besuchtesHaus)
        verify(entityManager, times(1)).flush()
    ***REMOVED***

    @Test
    fun ladeBesuchtesHausLiefertNullBeiIllegalArgumentException() {
        whenever(entityManager.find(BesuchtesHaus::class.java, -3L)).thenThrow(IllegalArgumentException::class.java)

        val besuchtesHaus = besuchtesHausDao.ladeBesuchtesHaus(-3L)

        verify(entityManager, times(1)).find(BesuchtesHaus::class.java, -3L)
        assertNull(besuchtesHaus)
    ***REMOVED***

    @Test
    fun ladeBesuchtesHausLiefertGefundenesBesuchtesHaus() {
        val besuchtesHaus = kanzlerinamt()
        whenever(entityManager.find(BesuchtesHaus::class.java, 1L)).thenReturn(besuchtesHaus)

        val ergebnis = besuchtesHausDao.ladeBesuchtesHaus(1L)

        verify(entityManager, times(1)).find(BesuchtesHaus::class.java, 1L)
        assertEquals(besuchtesHaus, ergebnis)
    ***REMOVED***

    @Test
    fun loescheBesuchtesHausLoeschtBesuchtesHaus() {
        val besuchtesHaus = kanzlerinamt()
        besuchtesHausDao.loescheBesuchtesHaus(besuchtesHaus)

        verify(entityManager, times(1)).remove(besuchtesHaus)
    ***REMOVED***

    @Test
    fun ladeAlleBesuchtenHaeuserErzeugtQuery() {
        whenever(entityManager.createQuery(anyString(), any<Class<BesuchtesHaus>>())).thenReturn(typedQuery)
        val besuchteHaeuser = listOf(kanzlerinamt(), hausundgrund(), konradadenauerhaus())
        whenever(typedQuery.resultList).thenReturn(besuchteHaeuser)

        val ergebnis = besuchtesHausDao.ladeAlleBesuchtenHaeuser()

        assertEquals(besuchteHaeuser, ergebnis)
    ***REMOVED***
***REMOVED***