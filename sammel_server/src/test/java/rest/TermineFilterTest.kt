package rest

import org.junit.Assert.*
import org.junit.Test
import java.time.LocalDate
import java.time.LocalTime

class TermineFilterTest {
    @Test
    fun erzeugtGefuelltenFilter() {
        val heute = LocalDate.now()
        val filter = TermineFilter(
                listOf("Sammel-Termin", "Info-Veranstaltung"),
                listOf(heute),
                LocalTime.of(12, 0 ,0),
                LocalTime.of(18, 0 ,0),
                listOf(StammdatenRestResource.OrtDto(0, "Friedrichshain-Kreuzberg", "Friedrichshain Nirdkiez")))

        assertTrue(filter.typen.containsAll(listOf("Sammel-Termin", "Info-Veranstaltung")))
        assertTrue(filter.tage.containsAll(listOf(heute)))
        assertEquals(filter.von?.hour,12)
        assertEquals(filter.bis?.hour, 18)
        assertEquals(filter.orte[0].id, 0)
    ***REMOVED***
***REMOVED***