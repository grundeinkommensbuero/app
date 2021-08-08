package de.kybernetik.rest

import de.kybernetik.database.vorbehalte.Vorbehalte
import de.kybernetik.shared.FehlenderWertException
import org.junit.Test

import org.junit.Assert.*
import java.time.LocalDate

class VorbehalteDtoTest {
    @Test(expected = FehlenderWertException::class)
    fun `convertToVorbehalte wirft Fehler bei fehlendem Benutzer`() {
        VorbehalteDto(
            0L,
            "Neubau (2), Kosten",
            null,
            LocalDate.of(2021, 8, 8),
            "Frankfurter Allee Nord"
        ).convertToVorbehalte()
    ***REMOVED***

    @Test(expected = FehlenderWertException::class)
    fun `convertToVorbehalte wirft Fehler bei fehlendem Datum`() {
        VorbehalteDto(
            0,
            "Neubau (2), Kosten",
            11L,
            null,
            "Frankfurter Allee Nord"
        ).convertToVorbehalte()
    ***REMOVED***

    @Test(expected = FehlenderWertException::class)
    fun `convertToVorbehalte wirft Fehler bei fehlendem Ort`() {
        VorbehalteDto(
            0L,
            "Neubau (2), Kosten",
            11L,
            LocalDate.of(2021, 8, 8),
            null
        ).convertToVorbehalte()
    ***REMOVED***

    @Test
    fun `convertToVorbehalte konvertiert vollstaendiges Dto`() {
        val vorbehalte = VorbehalteDto(
            1L,
            "Neubau (2), Kosten",
            11L,
            LocalDate.of(2021, 8, 8),
            "Frankfurter Allee Nord"
        ).convertToVorbehalte()

        assertEquals(1L, vorbehalte.id)
        assertEquals("Neubau (2), Kosten", vorbehalte.vorbehalte)
        assertEquals(11L, vorbehalte.benutzer)
        assertEquals(2021, vorbehalte.datum?.year)
        assertEquals(8, vorbehalte.datum?.month?.value)
        assertEquals(8, vorbehalte.datum?.dayOfMonth)
    ***REMOVED***

    @Test
    fun `convertToVorbehalte nutzt Default-Werte fuer Id und Vorbehalte`() {
        val vorbehalte = VorbehalteDto(
            null,
            null,
            11L,
            LocalDate.of(2021, 8, 8),
            "Frankfurter Allee Nord"
        ).convertToVorbehalte()

        assertEquals(0, vorbehalte.id)
        assertEquals("", vorbehalte.vorbehalte)
    ***REMOVED***

    @Test
    fun `convertFromVorbehalte konvertiert zu Dto`() {
        val vorbehalte = VorbehalteDto.convertFromVorbehalte(Vorbehalte(
            1L,
            "Neubau (2), Kosten",
            11L,
            LocalDate.of(2021, 8, 8),
            "Frankfurter Allee Nord"
        ))

        assertEquals(1L, vorbehalte.id)
        assertEquals("Neubau (2), Kosten", vorbehalte.vorbehalte)
        assertEquals(11L, vorbehalte.benutzer)
        assertEquals(2021, vorbehalte.datum?.year)
        assertEquals(8, vorbehalte.datum?.month?.value)
        assertEquals(8, vorbehalte.datum?.dayOfMonth)
    ***REMOVED***
***REMOVED***