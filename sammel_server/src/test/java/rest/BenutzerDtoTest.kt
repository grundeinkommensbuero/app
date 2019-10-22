package rest

import database.benutzer.Benutzer
import org.junit.Test

import org.junit.Assert.*

class BenutzerDtoTest {

    @Test
    fun convertToBenutzerMitAllem() {
        val dto = BenutzerDto(1L, "Karl Marx", "123456789")

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 1L)
        assertEquals(benutzer.name, "Karl Marx")
        assertEquals(benutzer.telefonnummer, "123456789")
    }

    @Test
    fun convertToBenutzerOhneId() {
        val dto = BenutzerDto(name = "Karl Marx", telefonnummer = "123456789")

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 0L)
        assertEquals(benutzer.name, "Karl Marx")
        assertEquals(benutzer.telefonnummer, "123456789")
    }

    @Test
    fun convertToBenutzerOhneTelefonnummer() {
        val dto = BenutzerDto(id = 1L, name = "Karl Marx")

        val benutzer = dto.convertToBenutzer()

        assertEquals(benutzer.id, 1L)
        assertEquals(benutzer.name, "Karl Marx")
        assertEquals(benutzer.telefonnummer, null)
    }

    @Test
    fun convertFromBenutzerMitAllem() {
        val benutzer = Benutzer(1, "Karl Marx", "passwort", "123456789")

        val dto = BenutzerDto.convertFromBenutzer(benutzer)

        assertEquals(dto.id, 1L)
        assertEquals(dto.name, "Karl Marx")
        assertEquals(dto.telefonnummer, "123456789")
    }

    @Test
    fun convertFromBenutzerMitId0() {
        val benutzer = Benutzer(0, "Karl Marx", "passwort", "123456789")

        val dto = BenutzerDto.convertFromBenutzer(benutzer)

        assertEquals(dto.id, 0L)
        assertEquals(dto.name, "Karl Marx")
        assertEquals(dto.telefonnummer, "123456789")
    }

    @Test
    fun convertFromBenutzerOhneTelefonnummer() {
        val benutzer = Benutzer(1, "Karl Marx", "passwort", null)

        val dto = BenutzerDto.convertFromBenutzer(benutzer)

        assertEquals(dto.id, 1L)
        assertEquals(dto.name, "Karl Marx")
        assertEquals(dto.telefonnummer, null)
    }
}