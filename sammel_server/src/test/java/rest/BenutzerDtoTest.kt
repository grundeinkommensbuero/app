package rest

import database.benutzer.Benutzer
import org.junit.Test

import org.junit.Assert.*

class BenutzerDtoTest {

    @Test
    fun convertToBenutzerMitAllem() {
        val dto = BenutzerDto(1L, "Karl Marx")

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 1L)
        assertEquals(benutzer.name, "Karl Marx")
    }

    @Test
    fun convertToBenutzerOhneId() {
        val dto = BenutzerDto(name = "Karl Marx")

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 0L)
        assertEquals(benutzer.name, "Karl Marx")
    }

    @Test
    fun convertFromBenutzer() {
        val benutzer = Benutzer(1, "Karl Marx")

        val dto = BenutzerDto.convertFromBenutzer(benutzer)

        assertEquals(dto.id, 1L)
        assertEquals(dto.name, "Karl Marx")
    }
}