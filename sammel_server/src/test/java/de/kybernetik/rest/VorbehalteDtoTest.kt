package de.kybernetik.rest

import de.kybernetik.database.vorbehalte.Vorbehalte
import de.kybernetik.shared.FehlenderWertException
import org.junit.Test

import org.junit.Assert.*
import java.time.LocalDate

class VorbehalteDtoTest {
    @Test(expected = FehlenderWertException::class)
    fun `convertToVorbehalte wirft Fehler bei fehlendem Datum`() {
        VorbehalteDto(
            0,
            "Neubau (2), Kosten",
            null,
            "10243"
        ).convertToVorbehalte(11L)
    ***REMOVED***

    @Test
    fun `convertToVorbehalte konvertiert vollstaendiges Dto`() {
        val vorbehalte = VorbehalteDto(
            1L,
            "Neubau (2), Kosten",
            LocalDate.of(2021, 8, 8),
            "10243"
        ).convertToVorbehalte(11L)

        assertEquals(1L, vorbehalte.id)
        assertEquals("Neubau (2), Kosten", vorbehalte.vorbehalte)
        assertEquals(11L, vorbehalte.benutzer)
        assertEquals(2021, vorbehalte.datum?.year)
        assertEquals(8, vorbehalte.datum?.month?.value)
        assertEquals(8, vorbehalte.datum?.dayOfMonth)
        assertEquals("10243", vorbehalte.ort)
    ***REMOVED***

    @Test
    fun `convertToVorbehalte nutzt Default-Werte fuer Id und Vorbehalte`() {
        val vorbehalte = VorbehalteDto(
            null,
            null,
            LocalDate.of(2021, 8, 8),
            null
        ).convertToVorbehalte(11L)

        assertEquals(0, vorbehalte.id)
        assertEquals("", vorbehalte.vorbehalte)
        assertEquals("Unbekannt", vorbehalte.ort)
    ***REMOVED***

    @Test
    fun `convertFromVorbehalte konvertiert zu Dto`() {
        val vorbehalte = VorbehalteDto.convertFromVorbehalte(Vorbehalte(
            1L,
            "Neubau (2), Kosten",
            11L,
            LocalDate.of(2021, 8, 8),
            "10243"
        ))

        assertEquals(1L, vorbehalte.id)
        assertEquals("Neubau (2), Kosten", vorbehalte.vorbehalte)
        assertEquals(2021, vorbehalte.datum?.year)
        assertEquals(8, vorbehalte.datum?.month?.value)
        assertEquals(8, vorbehalte.datum?.dayOfMonth)
        assertEquals("10243", vorbehalte.ort)
    ***REMOVED***
***REMOVED***