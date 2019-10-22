import database.stammdaten.Ort
import database.benutzer.Benutzer
import database.termine.Termin
import rest.TermineRestResource
import java.time.LocalDateTime

class TestdatenVorrat {
    companion object {
        fun nordkiez(): Ort {
            return Ort(1, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez")
        }

        fun treptowerPark(): Ort {
            return Ort(2, "Treptow-Köpenick", "Treptower Part")
        }

        fun goerli(): Ort {
            return Ort(3, "Friedrichshain-Kreuzberg", "Görlitzer Park und Umgebung")
        }

        fun sammeltermin(): String {
            return "Sammel-Termin"
        }

        fun infoveranstaltung(): String {
            return "Info-Veranstaltung"
        }

        fun karl(): Benutzer {
            return Benutzer(1, "Karl Marx", "Expropriation!", "123456789")
        }

        fun rosa(): Benutzer {
            return Benutzer(1, "Rosa Luxemburg", "Ich bin, ich war ich, werde sein", null)
        }

        fun terminOhneTeilnehmer(): Termin {
            return Termin(1,
                    LocalDateTime.of(2019, 10, 22, 16, 30, 0),
                    LocalDateTime.of(2019, 10, 22, 18, 0, 0),
                    nordkiez(),
                    sammeltermin(),
                    emptyList())
        }

        fun terminMitTeilnehmer(): Termin {
            return Termin(2,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    goerli(),
                    sammeltermin(),
                    listOf(karl(), rosa()))
        }

        fun terminDtoMitTeilnehmer(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTermin(terminMitTeilnehmer())
        }

        fun terminDtoOhneTeilnehmer(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTermin(terminOhneTeilnehmer())
        }
    }
}