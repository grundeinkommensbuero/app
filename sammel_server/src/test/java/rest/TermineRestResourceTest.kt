package rest

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.nordkiez
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.terminDto
import TestdatenVorrat.Companion.terminMitTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import database.DatabaseException
import database.benutzer.Benutzer
import database.benutzer.BenutzerDao
import database.termine.Termin
import database.termine.TermineDao
import database.termine.Token
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentCaptor
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import rest.TermineRestResource.*
import services.FirebaseService
import java.time.LocalDateTime.now
import javax.ejb.EJBException
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext
import kotlin.test.*

class TermineRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: TermineDao

    @Mock
    private lateinit var benutzerDao: BenutzerDao

    @Mock
    private lateinit var firebase: FirebaseService

    @Mock
    private lateinit var context: SecurityContext

    @InjectMocks
    private lateinit var resource: TermineRestResource

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
    ***REMOVED***

    @Test
    fun `TerminDto konvertiert zu Termin mit Teilnehmern`() {
        val beginn = now()
        val ende = now()
        val terminDto = TerminDto(1L, beginn, ende, nordkiez(), "Sammeln", 0.0, 1.0,
                listOf(BenutzerDto.convertFromBenutzer(karl())),
                TerminDetailsDto("treffpunkt", "kommentar", "kontakt"))

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
    fun `getTermin liefert Termin mit Details`() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val response = resource.getTermin(1L)

        verify(dao, atLeastOnce()).getTermin(1L)

        assertEquals(response.status, 200)
        val termin = response.entity as TerminDto
        assertEquals(termin.id, terminOhneTeilnehmerMitDetails().id)
    ***REMOVED***

    @Test
    fun `getTermin liefert 422 bei fehlender Id`() {
        val response = resource.getTermin(null)

        assertEquals(response.status, 422)
        val entity = response.entity as String
        assertEquals(entity, "Keine Aktions-ID angegeben")
    ***REMOVED***

    @Test
    fun `getTermin liefert 433 bei unbekannter Id`() {
        val response = resource.getTermin(2L)

        verify(dao, atLeastOnce()).getTermin(2L)

        assertEquals(response.status, 433)
        val entity = response.entity as String
        assertEquals(entity, "Unbekannte Aktion abgefragt")
    ***REMOVED***

    @Test
    fun `getTermineL liefert TerminDtos aus mit Filter`() {
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
    fun `getTermine nimmt fuer keinen Filter leeren Filter`() {
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
    fun `erstelleNeuenTermin legt Termin in Db ab`() {
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
    fun `erstelleNeuenTermin speichert Token in Db`() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val terminMitToken = ActionWithTokenDto(termin, "secretToken")
        val response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)
        verify(dao, times(1)).storeToken(1L, "secretToken")
    ***REMOVED***

    @Test
    fun `erstelleNeuenTermin speichert nicht leeres Token`() {
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
    fun `aktualisiereTermin reicht Fehler weiter bei Exception`() {
        val terminDto = terminDto()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 422)
        assertNull(response.entity)
    ***REMOVED***

    @Test
    fun `aktualisiereTermin aktualisiert Termin in Db`() {
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
    fun `deleteAction loescht Aktion und Token in Db`() {
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
    fun `deleteAction liefert 404 wenn Aktion n icht gefunden wird`() {
        val terminDto = terminDto()

        whenever(dao.deleteAction(any())).thenThrow(DatabaseException(""))
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 404)
    ***REMOVED***

    @Test
    fun `deleteAction prueft Token`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun `deleteAction liefert 403 bei falschem Token`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)
        verify(dao, never()).deleteAction(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 403)
    ***REMOVED***

    @Test
    fun `deleteAction loescht Aktion auch ohne Token wenn Aktion keinen NoToken in Db hat`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(null)
        val response: Response = resource.deleteAction(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).deleteAction(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun `editAction prueft Token`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun `editAction liefert 403  bei falschem Token`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 403)
    ***REMOVED***

    @Test
    fun `meldeTeilnahmeAn liefert 422 bei fehlender AktionsId`() {
        val response = resource.meldeTeilnahmeAn(null)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun `meldeTeilnahme an liefert 422 bei unbekannter AktionsId`() {
        val response = resource.meldeTeilnahmeAn(1)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun `meldeTeilnahmeAn ergaenzt TerminTeilnehmer um Benutzer`() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.meldeTeilnahmeAn(1)

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 1)
        assertEquals(captor.firstValue.teilnehmer[0].id, 11L)
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun `meldeTeilnahmeAn ignoriert bestehende Teilnahme`() {
        val termin = terminOhneTeilnehmerMitDetails()
        termin.teilnehmer = listOf(karl())
        whenever(dao.getTermin(1L)).thenReturn(termin)
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
        whenever(benutzerDao.getBenutzer(11)).thenReturn(karl())

        val response = resource.meldeTeilnahmeAn(1)

        verify(dao, never()).aktualisiereTermin(any())
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun `meldeTeilnahmeAn informiert Ersteller*in`() {
        val termin = terminMitTeilnehmerMitDetails()
        termin.teilnehmer = listOf(karl())
        whenever(dao.getTermin(2L)).thenReturn(termin)

        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("13"))
        val bini = Benutzer(13, "Bini Adamczak", 3L)
        whenever(benutzerDao.getBenutzer(13L)).thenReturn(bini)

        resource.meldeTeilnahmeAn(2)

        verify(firebase, times(1)).informiereUeberTeilnahme(bini, termin)
    ***REMOVED***

    @Test
    fun `sageTeilnahmeAb informiert Ersteller*in`() {
        val termin = terminMitTeilnehmerMitDetails()
        termin.teilnehmer = listOf(karl(), rosa())
        whenever(dao.getTermin(2L)).thenReturn(termin)

        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
        val user = karl()
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(user)

        resource.sageTeilnahmeAb(2)

        verify(firebase, times(1)).informiereUeberAbsage(user, termin)
    ***REMOVED***

    @Test
    fun sageTeilnahmeAbLiefert422BeiFehlenderAktionsId() {
        val response = resource.sageTeilnahmeAb(null)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun `sageTeilnahmeAb liefert 422 bei unbekannter AktionsId`() {
        val response = resource.sageTeilnahmeAb(1)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    ***REMOVED***

    @Test
    fun `sageTeilnahmeAb entfernt Benutzer als TerminTeilnehmer`() {
        val terminOhneTeilnehmerMitDetails = terminOhneTeilnehmerMitDetails()
        terminOhneTeilnehmerMitDetails.teilnehmer = listOf(karl())
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails)
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.sageTeilnahmeAb(1)

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 0)
        assertEquals(response.status, 202)
    ***REMOVED***

    @Test
    fun `sageTeilnahmeAb ignoriert fehlenden Benutzer in Liste`() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.sageTeilnahmeAb(1)

        verify(dao, never()).aktualisiereTermin(any())
        assertEquals(response.status, 202)
    ***REMOVED***
***REMOVED***