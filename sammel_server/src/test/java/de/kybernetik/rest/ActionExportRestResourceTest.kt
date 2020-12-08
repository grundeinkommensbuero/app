package de.kybernetik.rest

import TestdatenVorrat.Companion.terminOhneTeilnehmerMitDetails
import com.nhaarman.mockitokotlin2.any
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.termine.TermineDao
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.ActionExportRestResource.GeoJsonAction
import de.kybernetik.rest.ActionExportRestResource.GeoJsonAction.GeoJsonParseException
import de.kybernetik.rest.ActionExportRestResource.GeoJsonCollection
import java.time.LocalDate

class ActionExportRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: TermineDao

    @InjectMocks
    private lateinit var resource: ActionExportRestResource

    @Test
    fun `generates list of today and coming 7 days`() {
        resource.next7days.containsAll(
                listOf(LocalDate.now(),
                        LocalDate.now().plusDays(1),
                        LocalDate.now().plusDays(2),
                        LocalDate.now().plusDays(3),
                        LocalDate.now().plusDays(4),
                        LocalDate.now().plusDays(5),
                        LocalDate.now().plusDays(6),
                        LocalDate.now().plusDays(7))
        )
    ***REMOVED***

    @Test
    fun `getActionsAsGeoJson returns found actions in geoJson format`() {
        whenever(dao.getTermine(any())).thenReturn(listOf(
                terminOhneTeilnehmerMitDetails(),
                terminOhneTeilnehmerMitDetails(),
                terminOhneTeilnehmerMitDetails()))

        val response = resource.getActionsAsGeoJson()
        val entity = response.entity

        assertEquals(response.status, 200)
        assertEquals(entity::class, GeoJsonCollection::class)
        val collection = entity as GeoJsonCollection
        assertEquals(collection.features.size, 3)
    ***REMOVED***

    @Test
    fun `getActionsAsGeoJson filters actions without coordinates`() {
        val invalidAction = terminOhneTeilnehmerMitDetails()
        invalidAction.longitude = null
        whenever(dao.getTermine(any())).thenReturn(listOf(
                terminOhneTeilnehmerMitDetails(),
                terminOhneTeilnehmerMitDetails(),
                invalidAction))

        val response = resource.getActionsAsGeoJson()
        val entity = response.entity

        val collection = entity as GeoJsonCollection
        assertEquals(collection.features.size, 2)
    ***REMOVED***

    @Test(expected = GeoJsonParseException::class)
    fun `GeoJson parses not without latitude`() {
        val action = terminOhneTeilnehmerMitDetails()
        action.lattitude = null

        GeoJsonAction.convertFromAction(action)
    ***REMOVED***

    @Test(expected = GeoJsonParseException::class)
    fun `GeoJson parses not without longitude`() {
        val action = terminOhneTeilnehmerMitDetails()
        action.longitude = null

        GeoJsonAction.convertFromAction(action)
    ***REMOVED***

    @Test
    fun `GeoJson parses from Action`() {
        val geoJson = GeoJsonAction.convertFromAction(terminOhneTeilnehmerMitDetails())

        assertEquals(geoJson.type, "Feature")
        assertEquals(geoJson.properties.name, terminOhneTeilnehmerMitDetails().typ)
        assertEquals(geoJson.properties.description, GeoJsonAction.generateJsonDescription(terminOhneTeilnehmerMitDetails()))
        assertEquals(geoJson.geometry.type, "Point")
        assertEquals(geoJson.geometry.coordinates[0], terminOhneTeilnehmerMitDetails().longitude)
        assertEquals(geoJson.geometry.coordinates[1], terminOhneTeilnehmerMitDetails().lattitude)
    ***REMOVED***

    @Test
    fun `generateJsonDescription concatenates description, from, to and venue`() {
        val description = GeoJsonAction.generateJsonDescription(terminOhneTeilnehmerMitDetails())
        assertEquals(description, "Kommt zahlreich\n" +
                "\n" +
                "am 22.10.2019 ab 12:00 Uhr bis 15:00 Uhr\n" +
                "Treffpunkt: Weltzeituhr")
    ***REMOVED***

    @Test
    fun `generateJsonDescription uses placeholder if description is missing`() {
        val action = terminOhneTeilnehmerMitDetails()
        action.details!!.beschreibung = null
        val description = GeoJsonAction.generateJsonDescription(action)
        assertEquals(description, "Zu dieser Aktion gibt es keine Beschreibung\n" +
                "\n" +
                "am 22.10.2019 ab 12:00 Uhr bis 15:00 Uhr\n" +
                "Treffpunkt: Weltzeituhr")
    ***REMOVED***

    @Test
    fun `generateJsonDescription ignores date and times if date is missing`() {
        val action = terminOhneTeilnehmerMitDetails()
        action.beginn = null
        val description = GeoJsonAction.generateJsonDescription(action)
        assertEquals(description, "Kommt zahlreich\n" +
                "\n" +
                "Treffpunkt: Weltzeituhr")
    ***REMOVED***

    @Test
    fun `generateJsonDescription ignores end if end is missing`() {
        val action = terminOhneTeilnehmerMitDetails()
        action.ende = null
        val description = GeoJsonAction.generateJsonDescription(action)
        assertEquals(description, "Kommt zahlreich\n" +
                "\n" +
                "am 22.10.2019 ab 12:00 Uhr\n" +
                "Treffpunkt: Weltzeituhr")
    ***REMOVED***
***REMOVED***