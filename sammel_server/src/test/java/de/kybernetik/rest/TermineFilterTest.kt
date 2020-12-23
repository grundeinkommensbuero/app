package de.kybernetik.rest

import org.junit.Assert.*
import org.junit.Test
import java.time.LocalDate
import java.time.LocalTime

class TermineFilterTest {
    @Test
    fun erzeugtGefuelltenFilter() {
        val heute = LocalDate.now()
        val filter = TermineFilter(
                listOf("Sammeln", "Infoveranstaltung"),
                listOf(heute),
                LocalTime.of(12, 0 ,0),
                LocalTime.of(18, 0 ,0),
                listOf("Frankfurter Allee Nord"))

        assertTrue(filter.typen.containsAll(listOf("Sammeln", "Infoveranstaltung")))
        assertTrue(filter.tage.containsAll(listOf(heute)))
        assertEquals(filter.von?.hour,12)
        assertEquals(filter.bis?.hour, 18)
        assertEquals(filter.orte[0], "Frankfurter Allee Nord")
    ***REMOVED***
***REMOVED***