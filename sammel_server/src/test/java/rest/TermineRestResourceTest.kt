package rest

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.nordkiez
import TestdatenVorrat.Companion.terminDto
import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import database.DatabaseException
import database.benutzer.BenutzerDao
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
import rest.TermineRestResource.*
import java.time.LocalDateTime.now
import javax.ejb.EJBException
import javax.ws.rs.core.Response
import kotlin.test.*

class TermineRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: TermineDao

    @Mock
    private lateinit var benutzerDao: BenutzerDao

    @InjectMocks
    private lateinit var resource: TermineRestResource

    @Test
    fun TerminDtoKonvertiertZuTerminMitTeilnehmern() {
        val beginn = now()
        val ende = now()
        val terminDto = TerminDto(1L, beginn, ende, nordkiez(), "Sammeln", 0.0, 1.0,
                listOf(BenutzerDto.convertFromBenutzer(karl())),
                TerminDetailsDto(1L, "treffpunkt", "kommentar", "kontakt"))

        val termin = terminDto.convertToTermin()

        assertEquals(termin.id, 1L)
        assertEquals(termin.typ, "Sammeln")
        assertEquals(termin.beginn, beginn)
        assertEquals(termin.ende, ende)
        assertEquals(termin.ort?.id, 1)
        assertEquals(termin.lattitude, terminDto.lattitude)
        assertEquals(termin.longitude, terminDto.longitude)
        assertEquals(termin.teilnehmer.size, 1)
        assertEquals(termin.teilnehmer[0].id, 11L)
        assertEquals(termin.teilnehmer[0].name, "Karl Marx")
        assertEquals(termin.teilnehmer[0].color, 4294198070)
    ***REMOVED***

    @Test
    fun getTerminLiefertTerminMitDetails() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val response = resource.getTermin(1L)

        verify(dao, atLeastOnce()).getTermin(1L)

        assertEquals(response.status, 200)
        val termin = response.entity as TerminDto
        assertEquals(termin.id, terminOhneTeilnehmerMitDetails().id)
        assertEquals(termin.details?.id, terminOhneTeilnehmerMitDetails().details!!.id)
    ***REMOVED***

    @Test
    fun getTerminLiefert422BeiFehlenderId() {
        val response = resource.getTermin(null)

        assertEquals(response.status, 422)
        val entity = response.entity as String
        assertEquals(entity, "Keine Aktions-ID angegeben")
    ***REMOVED***

    @Test
    fun getTerminLiefert433BeiUnbekannterId() {
        val response = resource.getTermin(2L)

        verify(dao, atLeastOnce()).getTermin(2L)

        assertEquals(response.status, 433)
        val entity = response.entity as String
        assertEquals(entity, "Unbekannte Aktion abgefragt")
    ***REMOVED***

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
    ***REMOVED***

    @Test
    fun erstelleNeuenTerminStoresTokenInDb() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val terminMitToken = ActionWithTokenDto(termin, "secretToken")
        val response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)
        verify(dao, times(1)).storeToken(1L, "secretToken")
    ***REMOVED***

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
    ***REMOVED***

    @Test
    fun aktualisiereTerminReichtFehlerWeiterBeiUnbekannterId() {
        val terminDto = terminDto()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 422)
        assertNull(response.entity)
    ***REMOVED***

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
    ***REMOVED***

    @Test
    fun deleteActionDeletesActionAndTokenInDb() {
        val terminDto = terminDto()

        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 200)

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).deleteAction(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)

        val tokenCaptor = argumentCaptor<Token>()
        verify(dao, times(1)).deleteToken(tokenCaptor.capture())
        assertEquals(tokenCaptor.firstValue.actionId, 1L)
        assertEquals(tokenCaptor.firstValue.token, "token")
    ***REMOVED***

    @Test
    fun deleteActionReturns404IfActionNotFound() {
        val terminDto = terminDto()

        whenever(dao.deleteAction(any())).thenThrow(DatabaseException(""))
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 404)
    ***REMOVED***

    @Test
    fun deleteActionChecksToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun deleteActionDeniesWhenWithWrongToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)
        verify(dao, never()).deleteAction(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 403)
    ***REMOVED***

    @Test
    fun deleteActionDeletesActionButNoTokenIfActionHasNoTokenInDb() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(null)
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).deleteAction(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun editActionChecksToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun editActionDeniesWhenWithWrongToken() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 403)
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnLiefert422BeiFehlenderAktionsId() {
        val action = terminDto()
        action.id = null

        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = action))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnLiefert422BeiUnbekannterAktionsId() {
        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnLiefert422BeiFehlenderBenutzerId() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val user = BenutzerDto.convertFromBenutzer(karl())
        user.id = null

        val response = resource.meldeTeilnahmeAn(
                Participation(user = user, action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Der angegebene Benutzer ist ungültig")
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnLiefert422BeiUnbekannterBenutzerId() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Der angegebene Benutzer ist ungültig")
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnErgaenztTerminTeilnehmerUmBenutzer() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 1)
        assertEquals(captor.firstValue.teilnehmer[0].id, 11L)
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun meldeTeilnahmeAnIgnoriertBestehendeTeilnahme() {
        val termin = terminOhneTeilnehmerMitDetails()
        termin.teilnehmer = listOf(karl())
        whenever(dao.getTermin(1L)).thenReturn(termin)
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        verify(dao, never()).aktualisiereTermin(any())
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbLiefert422BeiFehlenderAktionsId() {
        val action = terminDto()
        action.id = null

        val response = resource.sageTeilnahmeAb(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = action))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbLiefert422BeiUnbekannterAktionsId() {
        val response = resource.sageTeilnahmeAb(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbLiefert422BeiFehlenderBenutzerId() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val user = BenutzerDto.convertFromBenutzer(karl())
        user.id = null

        val response = resource.sageTeilnahmeAb(
                Participation(user = user, action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Der angegebene Benutzer ist ungültig")
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbLiefert422BeiUnbekannterBenutzerId() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(1L)).thenReturn(null)

        val response = resource.meldeTeilnahmeAn(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Der angegebene Benutzer ist ungültig")
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbEntferntBenutzerAlsTerminTeilnehmer() {
        val terminOhneTeilnehmerMitDetails = terminOhneTeilnehmerMitDetails()
        terminOhneTeilnehmerMitDetails.teilnehmer = listOf(karl())
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails)
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.sageTeilnahmeAb(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 0)
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbIgnoriertFehlendenBenutzerInListe() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.sageTeilnahmeAb(
                Participation(user = BenutzerDto.convertFromBenutzer(karl()), action = terminDto()))

        verify(dao, never()).aktualisiereTermin(any())
        assertEquals(response.status, 202)
    ***REMOVED***
***REMOVED***