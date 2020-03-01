package rest

import TestdatenVorrat.Companion.nordkiez
import com.nhaarman.mockitokotlin2.whenever
import database.stammdaten.Ort
import database.stammdaten.StammdatenDao
import rest.StammdatenRestResource.OrtDto
import org.junit.Test

import org.junit.Assert.*
import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule

class StammdatenRestResourceTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: StammdatenDao

    @InjectMocks
    private lateinit var resource: StammdatenRestResource

    @Test
    fun getOrte() {
        val nordkiez = nordkiez()
        whenever(dao.getOrte()).thenReturn(listOf(nordkiez))

        val ergebnis = resource.getOrte()

        assertEquals(ergebnis.status, 200)
        val list = ergebnis.entity as List<*>
        assertEquals(list.size, 1)
        val ort = list[0]!! as OrtDto
        assertEquals(ort::class.java, OrtDto::class.java)
        assertEquals(ort, OrtDto.convertFromOrt(nordkiez))
    ***REMOVED***
***REMOVED***