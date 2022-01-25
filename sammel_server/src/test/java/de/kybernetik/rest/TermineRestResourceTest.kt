package de.kybernetik.rest

import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.bini
import TestdatenVorrat.Companion.terminDetails
import TestdatenVorrat.Companion.terminDto
import TestdatenVorrat.Companion.terminDtoMitDetails
import TestdatenVorrat.Companion.terminMitTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminMitTeilnehmerOhneDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import TestdatenVorrat.Companion.terminOhneTeilnehmerOhneDetails
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.DatabaseException
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.termine.Evaluation
import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TermineDao
import de.kybernetik.database.termine.Token
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentCaptor
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.TermineRestResource.*
import de.kybernetik.services.NeueAktionenNotification
import de.kybernetik.services.PushService
import java.time.LocalDateTime.now
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter.*
import javax.ejb.EJBException
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext
import kotlin.test.*

@ExperimentalStdlibApi
class TermineRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: TermineDao

    @Mock
    private lateinit var benutzerDao: BenutzerDao

    @Mock
    private lateinit var pushService: PushService

    @Suppress("unused")
    @Mock
    private lateinit var neueAktionenNotification: NeueAktionenNotification

    @Mock
    private lateinit var context: SecurityContext

    @InjectMocks
    private lateinit var resource: TermineRestResource

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
        reset(pushService)
        reset(dao)

        whenever(dao.ladeAlleEvaluationen()).thenReturn(
            listOf(
                Evaluation(1L, 1L, 1L, 5L, 20L, 3L, 2.0, "war ganz okay", "schlechtes Wetter", false),
                Evaluation(2L, 1L, 3L, 5L, 30L, 4L, 2.0, "super, gerne wieder", "Regen", false),
                Evaluation(3L, 2L, 1L, 5L, 12L, 2L, 1.0, "ziemlich wenig los", "Feiertag", false)
            )
        )

        val aktion1 = terminMitTeilnehmerOhneDetails()
        aktion1.id = 1L
        val aktion2 = terminMitTeilnehmerOhneDetails()
        aktion2.id = 2L
        val aktion3 = terminMitTeilnehmerOhneDetails()
        aktion3.id = 3L
        whenever(dao.getTermine(any(), anyOrNull())).thenReturn(listOf(aktion1, aktion2, aktion3))
    }

    @Test
    fun `TerminDto konvertiert zu Termin mit Teilnehmern`() {
        val beginn = now()
        val ende = now()
        val terminDto = TerminDto(
            1L, beginn, ende, "Frankfurter Allee Nord", "Sammeln", 0.0, 1.0,
            listOf(BenutzerDto.convertFromBenutzer(karl())),
            TerminDetailsDto("treffpunkt", "beschreibung", "kontakt")
        )

        val termin = terminDto.convertToTermin()

        assertEquals(termin.id, 1L)
        assertEquals(termin.typ, "Sammeln")
        assertEquals(termin.beginn, beginn)
        assertEquals(termin.ende, ende)
        assertEquals(termin.ort, "Frankfurter Allee Nord")
        assertEquals(termin.latitude, terminDto.latitude)
        assertEquals(termin.longitude, terminDto.longitude)
        assertEquals(termin.teilnehmer.size, 1)
        assertEquals(termin.teilnehmer[0].id, 11L)
        assertEquals(termin.teilnehmer[0].name, "Karl Marx")
        assertEquals(termin.teilnehmer[0].color, 4294198070)
    }

    @Test
    fun `getTermin liefert Termin mit Details`() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())

        val response = resource.getTermin(1L)

        verify(dao, atLeastOnce()).getTermin(1L)

        assertEquals(response.status, 200)
        val termin = response.entity as TerminDto
        assertEquals(termin.id, terminOhneTeilnehmerMitDetails().id)
    }

    @Test
    fun `getTermin liefert 422 bei fehlender Id`() {
        val response = resource.getTermin(null)

        assertEquals(response.status, 422)
        val entity = response.entity as String
        assertEquals(entity, "Keine Aktions-ID angegeben")
    }

    @Test
    fun `getTermin liefert 433 bei unbekannter Id`() {
        val response = resource.getTermin(2L)

        verify(dao, atLeastOnce()).getTermin(2L)

        assertEquals(response.status, 433)
        val entity = response.entity as String
        assertEquals(entity, "Unbekannte Aktion abgefragt")
    }

    @Test
    fun `getTermine liefert TerminDtos aus mit Filter`() {
        whenever(dao.getTermine(any(), anyOrNull())).thenReturn(
            listOf(
                terminOhneTeilnehmerOhneDetails(),
                terminOhneTeilnehmerMitDetails()
            )
        )
        val filter = TermineFilter()
        val response = resource.getTermine(filter)

        verify(dao, atLeastOnce()).getTermine(filter, 11L)

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
    fun `getTermine nimmt fuer keinen Filter leeren Filter`() {
        whenever(dao.getTermine(any(), anyOrNull())).thenReturn(
            listOf(
                terminOhneTeilnehmerOhneDetails(),
                terminOhneTeilnehmerMitDetails()
            )
        )
        resource.getTermine(null)

        val captor = ArgumentCaptor.forClass(TermineFilter::class.java)
        verify(dao, atLeastOnce()).getTermine(capture<TermineFilter>(captor), anyOrNull())
        assertEquals(captor.value.typen, emptyList())
        assertEquals(captor.value.tage, emptyList())
        assertEquals(captor.value.von, null)
        assertEquals(captor.value.bis, null)
        assertEquals(captor.value.orte, emptyList())
    }

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
    }

    @Test
    fun `erstelleNeuenTermin speichert Token in Db`() {
        val termin = terminDto()
        whenever(dao.erstelleNeuenTermin(any())).thenReturn(termin.convertToTermin())

        val terminMitToken = ActionWithTokenDto(termin, "secretToken")
        val response = resource.legeNeuenTerminAn(terminMitToken)

        assertEquals(response.status, 200)
        verify(dao, times(1)).storeToken(1L, "secretToken")
    }

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
    }

    @Test
    fun `aktualisiereTermin reicht Fehler weiter bei Exception`() {
        val terminDto = terminDto()
        whenever(dao.aktualisiereTermin(any())).thenThrow(EJBException())
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val terminAlt = terminMitTeilnehmerMitDetails()
        whenever(dao.getTermin(any())).thenReturn(terminAlt)

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 422)
        assertNull(response.entity)
    }

    @Test
    fun `aktualisiereTermin aktualisiert Termin in Db`() {
        val terminDto = terminDto()
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val terminAlt = terminMitTeilnehmerMitDetails()
        whenever(dao.getTermin(any())).thenReturn(terminAlt)

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)

        assertEquals(response.status, 200)
    }

    @Test
    fun `aktualisiereTermin aktualisiert nicht Teilnehmer`() {
        val terminAlt = terminMitTeilnehmerMitDetails()
        val terminNeu = terminDto()
        whenever(dao.getTermin(any())).thenReturn(terminAlt)
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        val response = resource.aktualisiereTermin(ActionWithTokenDto(terminNeu, "token"))

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertTrue(termin.teilnehmer.containsAll(terminAlt.teilnehmer))
        assertNotEquals(termin.teilnehmer.size, terminNeu.participants!!.size)

        assertEquals(response.status, 200)
    }

    @Test
    fun `aktualisiereTermin informiert Teilnehmer`() {
        val terminAlt = terminMitTeilnehmerMitDetails()
        val termin = terminDto()
        termin.participants = listOf(rosa(), karl()).map { BenutzerDto.convertFromBenutzer(it) }
        whenever(dao.getTermin(any())).thenReturn(terminAlt)
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))

        resource.aktualisiereTermin(ActionWithTokenDto(termin, "token"))

        val nachricht = argumentCaptor<PushMessageDto>()
        val empfaenger = argumentCaptor<List<Benutzer>>()
        verify(pushService)
            .sendePushNachrichtAnEmpfaenger(nachricht.capture(), empfaenger.capture())
        assertEquals(nachricht.firstValue.notification!!.title, "Eine Aktion an der du teilnimmst hat sich geändert")
        assertEquals(nachricht.firstValue.notification!!.body, "Sammeln am 22.10. in Frankfurter Allee Nord (null)")
        assertTrue(empfaenger.firstValue.map { it.id }.containsAll(listOf(12L)))
    }

    @Test
    fun `aktualisiereTermin prueft Token`() {
        val terminAlt = terminMitTeilnehmerMitDetails()
        whenever(dao.getTermin(any())).thenReturn(terminAlt)
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    }

    @Test
    fun `aktualisiereTermin liefert 403  bei falschem Token`() {
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        val response: Response = resource.aktualisiereTermin(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 403)
    }

    @Test
    fun `loescheAktion loescht Aktion und Token in Db`() {
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        val terminDto = terminDto()

        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val response: Response = resource.loescheAktion(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 200)

        val argCaptor = argumentCaptor<Termin>()
        verify(dao, times(1)).loescheAktion(argCaptor.capture())
        val termin = argCaptor.firstValue
        assertEquals(termin.id, terminDto.id)

        val tokenCaptor = argumentCaptor<Token>()
        verify(dao, times(1)).deleteToken(tokenCaptor.capture())
        assertEquals(tokenCaptor.firstValue.actionId, 1L)
        assertEquals(tokenCaptor.firstValue.token, "token")
    }

    @Test
    fun `loescheAktion liefert 404 wenn Aktion nicht gefunden wird`() {
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        val terminDto = terminDto()

        whenever(dao.loescheAktion(any())).thenThrow(DatabaseException(""))
        whenever(dao.loadToken(any())).thenReturn(Token(1L, "token"))
        val response: Response = resource.loescheAktion(ActionWithTokenDto(terminDto, "token"))

        assertEquals(response.status, 404)
    }

    @Test
    fun `loescheAktion prueft Token`() {
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "token"))
        val response: Response = resource.loescheAktion(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loadToken(1L)

        assertEquals(response.status, 200)
    }

    @Test
    fun `loescheAktion liefert 403 bei falschem Token`() {
        val terminDto = terminDto()
        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))

        val response: Response = resource.loescheAktion(ActionWithTokenDto(terminDto, "wrongToken"))

        verify(dao, times(1)).loadToken(1L)
        verify(dao, never()).loescheAktion(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 403)
    }

    @Test
    fun `loescheAktion informiert Teilnehmer`() {
        whenever(dao.loadToken(1L)).thenReturn(Token(1L, "rightToken"))
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        val terminDto = terminDto()

        resource.loescheAktion(ActionWithTokenDto(terminDto, "rightToken"))

        val data = argumentCaptor<PushMessageDto>()
        val empfaenger = argumentCaptor<List<Benutzer>>()
        verify(pushService)
            .sendePushNachrichtAnEmpfaenger(data.capture(), empfaenger.capture())
        assertEquals(data.firstValue.notification!!.title, "Eine Aktion an der du teilnimmst wurde abgesagt")
        assertEquals(
            data.firstValue.notification!!.body,
            "Sammeln am 22.10. in Frankfurter Allee Nord (null) wurde von der Ersteller*in gelöscht"
        )
        assertTrue(empfaenger.firstValue.map { it.id }.containsAll(listOf(12L)))
    }

    @Test
    fun `loescheAktion loescht Aktion auch ohne Token wenn Aktion keinen Token in Db hat`() {
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        val terminDto = terminDto()

        whenever(dao.loadToken(1L)).thenReturn(null)
        val response: Response = resource.loescheAktion(ActionWithTokenDto(terminDto, "token"))

        verify(dao, times(1)).loescheAktion(any())
        verify(dao, never()).deleteToken(any())

        assertEquals(response.status, 200)
    }

    @Test
    fun `meldeTeilnahmeAn liefert 422 bei fehlender AktionsId`() {
        val response = resource.meldeTeilnahmeAn(null)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    }

    @Test
    fun `meldeTeilnahme an liefert 422 bei unbekannter AktionsId`() {
        val response = resource.meldeTeilnahmeAn(1)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    }

    @Test
    fun `meldeTeilnahmeAn ergaenzt TerminTeilnehmer um Benutzer`() {
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(bini())

        val response = resource.meldeTeilnahmeAn(1)

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 3)
        assertEquals(captor.firstValue.teilnehmer[2].id, bini().id)
        assertEquals(response.status, 202)
    }

    @Test
    fun `meldeTeilnahmeAn informiert genau Ersteller und restliche Teilnehmer`() {
        val bini = bini()
        whenever(dao.getTermin(1L)).thenReturn(terminMitTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(bini)
        resource.meldeTeilnahmeAn(1)

        val empfaengerCaptor = argumentCaptor<List<Benutzer>>()
        val nachricht = argumentCaptor<PushMessageDto>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(
            nachricht.capture(),
            empfaengerCaptor.capture()
        )
        assertEquals(empfaengerCaptor.secondValue[0].name, rosa().name)
        assertEquals(empfaengerCaptor.secondValue.size, 1)
    }

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
    }

    @Test
    fun `informiereUeberTeilnahme informiert Ersteller`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val karl = karl()
        aktion.teilnehmer = listOf(karl)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberTeilnahme(bini, aktion)

        val nachricht = argumentCaptor<PushMessageDto>()
        val empfaengerCaptor = argumentCaptor<List<Benutzer>>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(
            nachricht.capture(),
            empfaengerCaptor.capture()
        )
        assertTrue(empfaengerCaptor.firstValue.containsAll(listOf(karl)))
        assertEquals("Verstärkung für deine Aktion", nachricht.firstValue.notification!!.title)
    }

    @Test
    fun `informiereUeberTeilnahme informiert restliche Teilnehmer`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val rosa = rosa()
        aktion.teilnehmer = listOf(karl(), rosa)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberTeilnahme(bini, aktion)
        val empfaengerCaptor = argumentCaptor<List<Benutzer>>()
        val nachricht = argumentCaptor<PushMessageDto>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(
            nachricht.capture(),
            empfaengerCaptor.capture()
        )
        assertTrue(empfaengerCaptor.secondValue.containsAll(listOf(rosa)))
        assertEquals("Verstärkung für eure Aktion", nachricht.secondValue.notification!!.title)
    }

    @Test
    fun `informiereUeberTeilnahme sendet Aktion, Benutzername und Typ`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val rosa = rosa()
        aktion.teilnehmer = listOf(karl(), rosa)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberTeilnahme(bini, aktion)

        val nachrichtCaptor = argumentCaptor<PushMessageDto>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(nachrichtCaptor.capture(), any())
        val data1 = nachrichtCaptor.firstValue.data!!
        val data2 = nachrichtCaptor.secondValue.data!!
        assertEquals(data1["channel"], "action:2")
        assertNotNull(data1["timestamp"])
        assertEquals(data1["action"], 2L)
        assertEquals(data1["username"], "Bini Adamczak")
        assertEquals(data1["joins"], true)
        assertEquals(data2["channel"], "action:2")
        assertNotNull(data2["timestamp"])
        assertEquals(data2["action"], 2L)
        assertEquals(data2["username"], "Bini Adamczak")
        assertEquals(data2["joins"], true)
    }

    @Test
    fun `sageTeilnahmeAb liefert 422 bei fehlender Aktions-Id`() {
        val response = resource.sageTeilnahmeAb(null)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    }

    @Test
    fun `sageTeilnahmeAb liefert 422 bei unbekannter AktionsId`() {
        val response = resource.sageTeilnahmeAb(1)

        assertEquals(response.status, 422)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Die angegebene Aktion ist ungültig")
    }

    @Test
    fun `sageTeilnahmeAb entfernt Benutzer als TerminTeilnehmer`() {
        val terminOhneTeilnehmerMitDetails = terminOhneTeilnehmerMitDetails()
        terminOhneTeilnehmerMitDetails.teilnehmer = listOf(karl(), rosa())
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails)
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("12"))
        whenever(benutzerDao.getBenutzer(12L)).thenReturn(rosa())

        val response = resource.sageTeilnahmeAb(1)

        val captor = argumentCaptor<Termin>()
        verify(dao, times(1)).aktualisiereTermin(captor.capture())
        assertEquals(captor.firstValue.teilnehmer.size, 1)
        assertEquals(response.status, 202)
    }

    @Test
    fun `sageTeilnahmeAb ignoriert fehlenden Benutzer in Liste`() {
        whenever(dao.getTermin(1L)).thenReturn(terminOhneTeilnehmerMitDetails())
        whenever(benutzerDao.getBenutzer(11L)).thenReturn(karl())

        val response = resource.sageTeilnahmeAb(1)

        verify(dao, never()).aktualisiereTermin(any())
        assertEquals(response.status, 202)
    }

    @Test
    fun `informiereUeberAbsage informiert Ersteller`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val karl = karl()
        aktion.teilnehmer = listOf(karl)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberAbsage(bini, aktion)

        val empfaengerCaptor = argumentCaptor<List<Benutzer>>()
        val nachrichtCaptor = argumentCaptor<PushMessageDto>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(
            nachrichtCaptor.capture(),
            empfaengerCaptor.capture()
        )
        assertTrue(empfaengerCaptor.firstValue.containsAll(listOf(karl)))
        assertEquals("Absage bei deiner Aktion", nachrichtCaptor.firstValue.notification!!.title)
    }

    @Test
    fun `informiereUeberAbsage informiert restliche Teilnehmer`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val rosa = rosa()
        aktion.teilnehmer = listOf(karl(), rosa)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberAbsage(bini, aktion)

        val nachrichtCaptor = argumentCaptor<PushMessageDto>()
        val empfaengerCaptor = argumentCaptor<List<Benutzer>>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(
            nachrichtCaptor.capture(),
            empfaengerCaptor.capture()
        )
        assertTrue(empfaengerCaptor.secondValue.containsAll(listOf(rosa)))
        assertEquals("Absage bei eurer Aktion", nachrichtCaptor.secondValue.notification!!.title)
    }

    @Test
    fun `informiereUeberAbsage sendet Inhalt`() {
        val aktion = terminMitTeilnehmerMitDetails()
        val rosa = rosa()
        aktion.teilnehmer = listOf(karl(), rosa)
        val bini = Benutzer(13, "Bini Adamczak", 3L)

        resource.informiereUeberAbsage(bini, aktion)

        val nachrichtCaptor = argumentCaptor<PushMessageDto>()
        verify(pushService, times(2)).sendePushNachrichtAnEmpfaenger(nachrichtCaptor.capture(), any())
        val data1 = nachrichtCaptor.firstValue.data!!
        val data2 = nachrichtCaptor.secondValue.data!!
        assertEquals(data1["channel"], "action:2")
        assertNotNull(data1["timestamp"])
        assertEquals(data1["action"], 2L)
        assertEquals(data1["username"], "Bini Adamczak")
        assertEquals(data1["joins"], false)
        assertEquals(data2["channel"], "action:2")
        assertNotNull(data2["timestamp"])
        assertEquals(data2["action"], 2L)
        assertEquals(data2["username"], "Bini Adamczak")
        assertEquals(data2["joins"], false)
    }

    @Test
    fun test() {
        println(ZonedDateTime.now().format(ISO_OFFSET_DATE_TIME))
        println(ZonedDateTime.now().format(ISO_ZONED_DATE_TIME))
        println(ZonedDateTime.now().format(ISO_INSTANT))
    }

    @Test
    fun `fragt alle Aktionen und alle Evaluationen aus Datenbank ab`() {
        resource.alleEvalationen()

        val captor = argumentCaptor<TermineFilter>()
        verify(dao, times(1)).getTermine(captor.capture(), anyOrNull())
        assertNull(captor.firstValue.von)
        assertNull(captor.firstValue.bis)
        assertEquals(captor.firstValue.tage, emptyList())
        assertEquals(captor.firstValue.orte, emptyList())
        assertEquals(captor.firstValue.typen, emptyList())

        verify(dao, times(1)).ladeAlleEvaluationen()
    }

    @Test
    fun `liefert alle Aktionen und Evaluationen aus`() {

        val ergebnis = resource.alleEvalationen()

        assertTrue(ergebnis.entity is EvaluationenUndAktionenDto)
        assertEquals(1L, (ergebnis.entity as EvaluationenUndAktionenDto).aktionen[0].id)
        assertEquals(2L, (ergebnis.entity as EvaluationenUndAktionenDto).aktionen[1].id)
        assertEquals(3L, (ergebnis.entity as EvaluationenUndAktionenDto).aktionen[2].id)
        assertEquals(1L, (ergebnis.entity as EvaluationenUndAktionenDto).evaluationen[0].id)
        assertEquals(2L, (ergebnis.entity as EvaluationenUndAktionenDto).evaluationen[1].id)
    }

    @Test
    fun `liefert Aktionen ohne Teilnehmer aus`() {

        val ergebnis = resource.alleEvalationen()

        assertTrue(ergebnis.entity is EvaluationenUndAktionenDto)
        assertNull((ergebnis.entity as EvaluationenUndAktionenDto).aktionen[0].participants)
        assertNull((ergebnis.entity as EvaluationenUndAktionenDto).aktionen[1].participants)
        assertNull((ergebnis.entity as EvaluationenUndAktionenDto).aktionen[2].participants)
    }

    @Test
    fun `convertFromEvaluation konvertiert Evaluation zu Dto`() {
        val evaluation = Evaluation(1L, 2L, 3L, 4, 5L, 4L, 3.0, "ganz okay", "Sonnenschein", false)

        val dto = EvaluationDto.vonEvaluation(evaluation)
        assertEquals(1L, dto.id)
        assertEquals(2L, dto.termin_id)
        assertEquals(4, dto.teilnehmer)
        assertEquals(5L, dto.unterschriften)
        assertEquals(4L, dto.bewertung)
        assertEquals(3.0, dto.stunden)
        assertEquals("ganz okay", dto.kommentar)
        assertEquals("Sonnenschein", dto.situation)
        assertEquals(false, dto.ausgefallen)
    }
}
