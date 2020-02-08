package rest

import TestdatenVorrat.Companion.terminDto
import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import database.DatabaseException
import database.termine.Termin
import database.termine.TermineDao
import database.termine.Token
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentCaptor
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.TermineRestResource.ActionWithTokenDto
import rest.TermineRestResource.TerminDto
import javax.ejb.EJBException
import javax.ws.rs.core.Response
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
    }

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
    }

    @Test
    fun erstelleNeuenTerminTerminAnLegtTerminInDbAb() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val terminMitToken = ActionWithTokenDto(termin, "")
        val response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)
        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).erstelleNeuenTermin(argCaptor.capture())
        val terminInDb = argCaptor.firstValue
        assertEquals(terminInDb.id, termin.id)
    }

    @Test
    fun erstelleNeuenTerminStoresTokenInDb() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val terminMitToken = ActionWithTokenDto(termin, "secretToken")
        val response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)
        verify(dao, times(1)).storeToken(1L, "secretToken")
    }

    @Test
    fun erstelleNeuenTerminDoesNotStoreEmptyToken() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        var terminMitToken = ActionWithTokenDto(termin, "")
        var response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)

        terminMitToken = ActionWithTokenDto(termin, null)
        response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)

        verify(dao, never()).storeToken(any(), any())
    }

    @Test
    fun aktualisiereTerminReichtFehlerWeiterBeiUnbekannterId() {
        val terminDto = terminDto()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 422)
        assertNull(response.entity)
    }

    @Test
    fun aktualisiereTerminAktualisiertTerminInDb() {
        val terminDto = terminDto()
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)

        assertEquals(response.status, 200)
    }

    @Test
    fun deleteActionDeletesActionInDb() {
        val terminDto = terminDto()

        whenever(dao.loadToken(any())).thenReturn(Token(any(),"token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 200)

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).deleteAction(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)
    }

    @Test
    fun deleteActionReturns404IfActionNotFound() {
        val terminDto = terminDto()

        whenever(dao.deleteAction(any())).thenThrow(DatabaseException(""))
        whenever(dao.loadToken(any())).thenReturn(Token(1L,"token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 404)
    }

    @Test
    fun deleteActionChecksToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L,"token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    }

    @Test
    fun deleteActionDeniesWhenWithWrongToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L,"rightToken"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 403)
    }

    @Test
    fun editActionChecksToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L,"token"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    }

    @Test
    fun editActionDeniesWhenWithWrongToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L,"rightToken"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 403)
    }
}