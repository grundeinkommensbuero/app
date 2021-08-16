package de.kybernetik.database.plakate

import org.junit.Test

import org.junit.Assert.*
import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import TestdatenVorrat.Companion.plakat1
import TestdatenVorrat.Companion.plakat2
import TestdatenVorrat.Companion.plakat3
import com.nhaarman.mockitokotlin2.*
import org.mockito.ArgumentMatchers.anyString
import java.lang.IllegalArgumentException

class PlakateDaoTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager
    @Mock
    private lateinit var typedQuery: TypedQuery<Plakat>

    @InjectMocks
    private lateinit var plakateDao: PlakateDao

    @Test
    fun erstellePlakatPersistiertPlakat() {
        val plakat = plakat1()
        plakateDao.erstellePlakat(plakat)

        verify(entityManager, times(1)).persist(plakat)
        verify(entityManager, times(1)).flush()
    ***REMOVED***

    @Test
    fun ladePlakatLiefertNullBeiIllegalArgumentException() {
        whenever(entityManager.find(Plakat::class.java, -3L)).thenThrow(IllegalArgumentException::class.java)

        val plakat = plakateDao.ladePlakat(-3L)

        verify(entityManager, times(1)).find(Plakat::class.java, -3L)
        assertNull(plakat)
    ***REMOVED***

    @Test
    fun ladePlakatLiefertGefundenesPlakat() {
        val plakat = plakat1()
        whenever(entityManager.find(Plakat::class.java, 1L)).thenReturn(plakat)

        val ergebnis = plakateDao.ladePlakat(1L)

        verify(entityManager, times(1)).find(Plakat::class.java, 1L)
        assertEquals(plakat, ergebnis)
    ***REMOVED***

    @Test
    fun loeschePlakatLoeschtPlakat() {
        val plakat = plakat1()
        plakateDao.loeschePlakat(plakat)

        verify(entityManager, times(1)).remove(plakat)
    ***REMOVED***

    @Test
    fun ladeAllePlakateErzeugtQuery() {
        whenever(entityManager.createQuery(anyString(), any<Class<Plakat>>())).thenReturn(typedQuery)
        val plakate = listOf(plakat1(), plakat2(), plakat3())
        whenever(typedQuery.resultList).thenReturn(plakate)

        val ergebnis = plakateDao.ladeAllePlakate()

        assertEquals(plakate, ergebnis)
    ***REMOVED***
***REMOVED***