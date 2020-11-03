package de.kybernetik.rest

import de.kybernetik.database.benutzer.Benutzer
import org.junit.Test

import org.junit.Assert.*

class BenutzerDtoTest {

    @Test
    fun convertToBenutzerMitAllem() {
        val dto = BenutzerDto(11L, "Karl Marx", 4294198070)

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 11L)
        assertEquals(benutzer.name, "Karl Marx")
        assertEquals(benutzer.color, 4294198070)
    ***REMOVED***

    @Test
    fun convertToBenutzerOhneId() {
        val dto = BenutzerDto(name = "Karl Marx", color = 4294198070)

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 0L)
        assertEquals(benutzer.name, "Karl Marx")
        assertEquals(benutzer.color, 4294198070)
    ***REMOVED***

    @Test
    fun convertFromBenutzer() {
        val benutzer = Benutzer(11, "Karl Marx", 4294198070)

        val dto = BenutzerDto.convertFromBenutzer(benutzer)

        assertEquals(dto.id, 11L)
        assertEquals(dto.name, "Karl Marx")
        assertEquals(dto.color, 4294198070)
    ***REMOVED***
***REMOVED***