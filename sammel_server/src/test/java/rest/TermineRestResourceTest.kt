package rest

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.terminDtoMitTeilnehmer
import TestdatenVorrat.Companion.terminMitTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminMitTeilnehmerOhneDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import database.termine.Termin
import database.termine.TermineDao
import org.junit.Rule
import org.junit.Test
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
    fun getTermineLiefertTerminDtosAus() {
        whenever(dao.getTermine()).thenReturn(listOf(terminOhneTeilnehmerOhneDetails(), terminMitTeilnehmerMitDetails()))
        val response = resource.getTermine()

        assertEquals(response.status, 200)
        val termine = response.entity as List<*>
        assertEquals(termine.size, 2)
        assertEquals(termine[0]!!::class.java, TerminDto::class.java)
        val termin1 = termine[0] as TerminDto
        val termin2 = termine[1] as TerminDto
        assertEquals(termin1.id, terminOhneTeilnehmerOhneDetails().id)
        assertEquals(termin1.teilnehmer?.size, 0)
        assertEquals(termin2.id, terminMitTeilnehmerOhneDetails().id)
        assertEquals(termin2.teilnehmer?.size, 2)
        assertEquals(termin2.teilnehmer?.get(0)?.name, karl().name)
        assertEquals(termin2.teilnehmer?.get(1)?.name, rosa().name)
    }

    @Test
    fun legeNeuenTerminAnLegtTerminInDbAb() {
        val termin = terminDtoMitTeilnehmer()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val response = resource.legeNeuenTerminAn(termin)

        assertEquals(response.status, 200)
        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).erstelleNeuenTermin(argCaptor.capture())
        val terminInDb = argCaptor.firstValue
        assertEquals(terminInDb.id, termin.id)
        assertEquals(terminInDb.teilnehmer.size, 2)
        assertEquals(terminInDb.teilnehmer[0].name, karl().name)
    }

    @Test
    fun aktualisiereTerminReichtFehlerWeiterBeiUnbekannterId() {
        val terminDto = terminDtoMitTeilnehmer()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())

        val response = resource.aktualisiereTermin(terminDto)

        assertEquals(response.status, 422)
        assertNull(response.entity)
    }

    @Test
    fun aktualisiereTerminAktualisiertTerminInDb() {
        val terminDto = terminDtoMitTeilnehmer()

        resource.aktualisiereTermin(terminDto)

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)
        assertEquals(termin.teilnehmer.size, 2)
        assertEquals(termin.teilnehmer[0].name, karl().name)
    }
}