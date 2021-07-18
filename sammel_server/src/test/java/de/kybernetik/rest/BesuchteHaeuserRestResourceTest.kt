@file:Suppress("UNCHECKED_CAST")

package de.kybernetik.rest

import TestdatenVorrat.Companion.hausundgrund
import TestdatenVorrat.Companion.kanzlerinamt
import TestdatenVorrat.Companion.konradadenauerhaus
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.besuchteshaus.BesuchtesHaus
import de.kybernetik.database.besuchteshaus.BesuchtesHausDao
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.time.LocalDate
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals

class BesuchteHaeuserRestResourceTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: BesuchtesHausDao

    @Mock
    lateinit var context: SecurityContext

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
    ***REMOVED***

    @InjectMocks
    private lateinit var besuchteHaeuserRestResource: BesuchteHaeuserRestResource

    @Test
    fun getBesuchteHaeuserKonvertiertAlleBesuchtenHaeuserVonDao() {
        whenever(dao.ladeAlleBesuchtenHaeuser()).thenReturn(
            listOf(
                kanzlerinamt(),
                hausundgrund(),
                konradadenauerhaus()
            )
        )

        val besuchteHaeuser = besuchteHaeuserRestResource.getBesuchteHaeuser()

        verify(dao, times(1)).ladeAlleBesuchtenHaeuser()

        val entity = besuchteHaeuser.entity as List<BesuchtesHausDto>
        assertEquals(1L, entity[0].id)
        assertEquals("Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557", entity[0].adresse)
        assertEquals(2L, entity[1].id)
        assertEquals("Potsdamer Straße 143, 10783 Berlin", entity[1].adresse)
        assertEquals(3L, entity[2].id)
        assertEquals("Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785", entity[2].adresse)
    ***REMOVED***

        @Test
    fun erstelleBesuchtesHausRuftDaoAufUndKonvertiertDto() {
        whenever(dao.erstelleBesuchtesHaus(any())).thenReturn(
            BesuchtesHaus(
                0,
                52.47541,
                13.30508,
                "Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197",
                "Haupteingang",
                LocalDate.of(2021, 7, 18),
                11
            )
        )

        besuchteHaeuserRestResource.erstelleBesuchtesHaus(
            BesuchtesHausDto(
                0,
                52.47541,
                13.30508,
                "Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197",
                "Haupteingang",
                LocalDate.of(2021, 7, 18),
                11
            )
        )

        val argCaptor = argumentCaptor<BesuchtesHaus>()
        verify(dao, times(1)).erstelleBesuchtesHaus(argCaptor.capture())

        assertEquals(0, argCaptor.firstValue.id)
        assertEquals(
            "Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197",
            argCaptor.firstValue.adresse
        )
    ***REMOVED***

    @Test
    fun erstelleBesuchtesHausKorrigiertBenutzer() {
        whenever(dao.erstelleBesuchtesHaus(any())).thenReturn(
            BesuchtesHaus(
                0,
                52.47541,
                13.30508,
                "Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197",
                "Haupteingang",
                LocalDate.of(2021, 7, 18),
                11
            )
        )

        val response = besuchteHaeuserRestResource.erstelleBesuchtesHaus(
            BesuchtesHausDto(
                0,
                52.47541,
                13.30508,
                "Mecklenburgische Straße 57, Wilmersdorf, Charlottenburg-Wilmersdorf, Berlin, 14197",
                "Haupteingang",
                LocalDate.of(2021, 7, 18),
                12
            )
        )

        val argCaptor = argumentCaptor<BesuchtesHaus>()
        verify(dao, times(1)).erstelleBesuchtesHaus(argCaptor.capture())
        assertEquals(11, argCaptor.firstValue.user_id)

        assertEquals(200, response.status)
    ***REMOVED***

    @Test
    fun loescheBesuchtesHausErwartetIdAlsPathParameter() {
        val response = besuchteHaeuserRestResource.loescheBesuchtesHaus(null)

        assertEquals(422, response.status)
        assertEquals("Kein Besuchtes Haus an den Server gesendet", (response.entity as RestFehlermeldung).meldung)
        verify(dao, never()).loescheBesuchtesHaus(any())
    ***REMOVED***

    @Test
    fun loescheBesuchtesHausErwartetExistierendeIdAlsPathParameter() {
        whenever(dao.ladeBesuchtesHaus(4)).thenReturn(null)

        val response = besuchteHaeuserRestResource.loescheBesuchtesHaus(4)

        assertEquals(422, response.status)
        assertEquals("Keine gültiges Besuchtes Haus an den Server gesendet", (response.entity as RestFehlermeldung).meldung)
        verify(dao, never()).loescheBesuchtesHaus(any())
    ***REMOVED***

    @Test
    fun loescheBesuchtesHausWeistFalschenBenutzerZurueck() {
        whenever(dao.ladeBesuchtesHaus(2)).thenReturn(hausundgrund())

        val response = besuchteHaeuserRestResource.loescheBesuchtesHaus(2)

        assertEquals(403, response.status)
        assertEquals("Haus wurde von einer anderen Benutzer*in eingetragen", (response.entity as RestFehlermeldung).meldung)
        verify(dao, never()).loescheBesuchtesHaus(any())
    ***REMOVED***

    @Test
    fun loescheBesuchtesHausAkzeptiertRichtigenBenutzerUndLoeschtHaus() {
        val kanzlerinamt = kanzlerinamt()
        whenever(dao.ladeBesuchtesHaus(1)).thenReturn(kanzlerinamt)

        val response = besuchteHaeuserRestResource.loescheBesuchtesHaus(1)

        assertEquals(200, response.status)
        verify(dao, times(1)).loescheBesuchtesHaus(kanzlerinamt)
    ***REMOVED***
***REMOVED***