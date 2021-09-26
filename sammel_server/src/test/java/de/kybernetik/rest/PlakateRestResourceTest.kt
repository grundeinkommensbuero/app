@file:Suppress("UNCHECKED_CAST")

package de.kybernetik.rest

import TestdatenVorrat.Companion.plakat1
import TestdatenVorrat.Companion.plakat2
import TestdatenVorrat.Companion.plakat3
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.plakate.Plakat
import de.kybernetik.database.plakate.PlakateDao
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before
import org.junit.Test

import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class PlakateRestResourceTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: PlakateDao

    @Mock
    lateinit var context: SecurityContext

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
        System.setProperty("de.kybernetik.plakate.secret", "false")
    ***REMOVED***

    @InjectMocks
    private lateinit var plakateRestResource: PlakateRestResource

    @Test
    fun getPlakateLiefertLeereListeWennPlakateGeheim() {
        System.setProperty("de.kybernetik.plakate.secret", "true")

        val plakate = plakateRestResource.getPlakate()

        assertTrue((plakate.entity as List<Plakat>).isEmpty())
    ***REMOVED***

    @Test
    fun getPlakateKonvertiertAllePlakateVonDao() {
        whenever(dao.ladeAllePlakate()).thenReturn(
            listOf(
                plakat1(),
                plakat2(),
                plakat3()
            )
        )

        val plakate = plakateRestResource.getPlakate()

        verify(dao, times(1)).ladeAllePlakate()

        val entity = plakate.entity as List<PlakatDto>
        assertEquals(1L, entity[0].id)
        assertEquals("12161, Friedrich-Wilhelm-Platz 57", entity[0].adresse)
        assertEquals(2L, entity[1].id)
        assertEquals("12161, Bundesallee 76", entity[1].adresse)
        assertEquals(3L, entity[2].id)
        assertEquals("12161, Goßlerstraße 29", entity[2].adresse)
    ***REMOVED***

    @Test
    fun erstellePlakatRuftDaoAufUndKonvertiertDto() {
        whenever(dao.erstellePlakat(any())).thenReturn(
            Plakat(
                0,
                52.47065,
                13.3285,
                "12161, Bundesallee 129",
                11,
                false
            )
        )

        plakateRestResource.erstellePlakat(
            PlakatDto(
                0,
                52.47065,
                13.3285,
                "12161, Bundesallee 129",
                11,
                false
            )
        )

        val argCaptor = argumentCaptor<Plakat>()
        verify(dao, times(1)).erstellePlakat(argCaptor.capture())

        assertEquals(0, argCaptor.firstValue.id)
        assertEquals("12161, Bundesallee 129", argCaptor.firstValue.adresse)
    ***REMOVED***

    @Test
    fun erstellePlakatKorrigiertBenutzer() {
        whenever(dao.erstellePlakat(any())).thenReturn(
            Plakat(
                0,
                52.47065,
                13.3285,
                "12161, Bundesallee 129",
                11,
                false
            )
        )

        val response = plakateRestResource.erstellePlakat(
            PlakatDto(
                0,
                52.47065,
                13.3285,
                "12161, Bundesallee 129",
                12,
                false
            )
        )

        val argCaptor = argumentCaptor<Plakat>()
        verify(dao, times(1)).erstellePlakat(argCaptor.capture())
        assertEquals(11, argCaptor.firstValue.user_id)

        assertEquals(200, response.status)
    ***REMOVED***

    @Test
    fun erstellePlakatLiefertPlakatDtoVonDBZurueck() {
        whenever(dao.erstellePlakat(any())).thenReturn(
            Plakat(
                0,
                52.47065,
                13.3285,
                "Plakat aus der Datenbank",
                11,
                false
            )
        )

        val response = plakateRestResource.erstellePlakat(
            PlakatDto(
                0,
                52.47065,
                13.3285,
                "Plakat von der App",
                12,
                false
            )
        )

        assertEquals("Plakat aus der Datenbank", (response.entity as PlakatDto).adresse)
    ***REMOVED***

    @Test
    fun loeschePlakatErwartetIdAlsPathParameter() {
        val response = plakateRestResource.loeschePlakat(null)

        assertEquals(422, response.status)
        assertEquals("Kein Plakat an den Server gesendet", (response.entity as RestFehlermeldung).meldung)
        verify(dao, never()).loeschePlakat(any())
    ***REMOVED***

    @Test
    fun loeschePlakateErwartetExistierendeIdAlsPathParameter() {
        whenever(dao.ladePlakat(4)).thenReturn(null)

        val response = plakateRestResource.loeschePlakat(4)

        assertEquals(422, response.status)
        assertEquals(
            "Keine gültiges Plakat an den Server gesendet",
            (response.entity as RestFehlermeldung).meldung
        )
        verify(dao, never()).loeschePlakat(any())
    ***REMOVED***

    @Test
    fun loeschePlakatWeistFalschenBenutzerZurueck() {
        whenever(dao.ladePlakat(2)).thenReturn(plakat2())

        val response = plakateRestResource.loeschePlakat(2)

        assertEquals(403, response.status)
        assertEquals(
            "Plakat wurde von einer anderen Benutzer*in eingetragen",
            (response.entity as RestFehlermeldung).meldung
        )
        verify(dao, never()).loeschePlakat(any())
    ***REMOVED***

    @Test
    fun loeschePlakatAkzeptiertRichtigenBenutzerUndLoeschtHaus() {
        val plakat = plakat1()
        whenever(dao.ladePlakat(1)).thenReturn(plakat)

        val response = plakateRestResource.loeschePlakat(1)

        assertEquals(200, response.status)
        verify(dao, times(1)).loeschePlakat(plakat)
    ***REMOVED***
***REMOVED***