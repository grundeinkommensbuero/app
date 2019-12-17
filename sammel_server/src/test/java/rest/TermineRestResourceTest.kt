package rest

import TestdatenVorrat.Companion.terminDto
import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import database.termine.Termin
import database.termine.TermineDao
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentCaptor
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.TermineRestResource.TerminDto
import javax.ejb.EJBException
import kotlin.test.*

class TermineRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: TermineDao

    @InjectMocks
    private lateinit var resource: TermineRestResource

    @Test
    fun getTermineLiefertTerminDtosAusMitFilter() {
        whenever(dao.getTermine(any())).thenReturn(listOf(terminOhneTeilnehmerOhneDetails(), terminOhneTeilnehmerMitDetails()))
        val filter = TermineFilter()
        val response = resource.getTermine(filter)

        verify(dao, atLeastOnce()).getTermine(filter)

        assertEquals(response.status, 200)
        val termine = response.entity as List<*>
//        assertEquals(termine.size, 2)
        assertEquals(termine[0]!!::class.java, TerminDto::class.java)
        val termin1 = termine[0] as TerminDto
        val termin2 = termine[1] as TerminDto
        assertEquals(termin1.id, terminOhneTeilnehmerOhneDetails().id)
        assertEquals(termin2.id, terminOhneTeilnehmerMitDetails().id)
    ***REMOVED***

    @Test
    fun getTermineNimmtFuerKeinenFilterLeerenFilter() {
        whenever(dao.getTermine(any())).thenReturn(listOf(terminOhneTeilnehmerOhneDetails(), terminOhneTeilnehmerMitDetails()))
        resource.getTermine(null)

        val captor = ArgumentCaptor.forClass(TermineFilter::class.java)
        verify(dao, atLeastOnce()).getTermine(capture<TermineFilter>(captor))
        assertEquals(captor.value.typen, emptyList())
        assertEquals(captor.value.tage, emptyList())
        assertEquals(captor.value.von, null)
        assertEquals(captor.value.bis, null)
        assertEquals(captor.value.orte, emptyList())
    ***REMOVED***

    @Test
    fun legeNeuenTerminAnLegtTerminInDbAb() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val response = resource.legeNeuenTerminAn(termin)

        assertEquals(response.status, 200)
        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).erstelleNeuenTermin(argCaptor.capture())
        val terminInDb = argCaptor.firstValue
        assertEquals(terminInDb.id, termin.id)
    ***REMOVED***

    @Test
    fun aktualisiereTerminReichtFehlerWeiterBeiUnbekannterId() {
        val terminDto = terminDto()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())

        val response = resource.aktualisiereTermin(terminDto)

        assertEquals(response.status, 422)
        assertNull(response.entity)
    ***REMOVED***

    @Test
    fun aktualisiereTerminAktualisiertTerminInDb() {
        val terminDto = terminDto()

        resource.aktualisiereTermin(terminDto)

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)
    ***REMOVED***
***REMOVED***