import database.stammdaten.Ort
import database.benutzer.Benutzer
import database.listlocations.ListLocation
import database.termine.Termin
import database.termine.TerminDetails
import rest.TermineRestResource
import java.time.LocalDateTime

class TestdatenVorrat {
    companion object {
        fun nordkiez(): Ort {
            return Ort(1, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez", 52.51579, 13.45399)
        }

        fun treptowerPark(): Ort {
            return Ort(2, "Treptow-Köpenick", "Treptower Part", 52.48993, 13.46839)
        }

        fun goerli(): Ort {
            return Ort(3, "Friedrichshain-Kreuzberg", "Görlitzer Park und Umgebung", 52.49653, 13.43762)
        }

        fun sammeltermin(): String {
            return "Sammeln"
        }

        fun infoveranstaltung(): String {
            return "Infoveranstaltung"
        }

        fun karl(): Benutzer {
            return Benutzer(1, "Karl Marx")
        }

        fun rosa(): Benutzer {
            return Benutzer(1, "Rosa Luxemburg")
        }

        fun terminOhneTeilnehmerOhneDetails(): Termin {
            return Termin(1,
                    LocalDateTime.of(2019, 10, 22, 16, 30, 0),
                    LocalDateTime.of(2019, 10, 22, 18, 0, 0),
                    nordkiez(),
                    sammeltermin(),
                    emptyList(),
                    52.48612,
                    13.47192,
                    null)
        }

        fun terminMitTeilnehmerOhneDetails(): Termin {
            return Termin(2,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    goerli(),
                    sammeltermin(),
                    listOf(karl(), rosa()),
                    52.48612,
                    13.47192,
                    null)
        }

        fun terminMitTeilnehmerMitDetails(): Termin {
            return Termin(2,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    goerli(),
                    sammeltermin(),
                    listOf(karl(), rosa()),
                    52.48612,
                    13.47192,
                    terminDetails())
        }

        fun terminOhneTeilnehmerMitDetails(): Termin {
            return Termin(2,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    goerli(),
                    sammeltermin(),
                    emptyList(),
                    52.48612,
                    13.47192,
                    terminDetails())
        }

        fun terminDto(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTerminWithoutDetails(terminOhneTeilnehmerOhneDetails())
        }

        internal fun terminDetails(): TerminDetails {
            return TerminDetails(1, "Weltzeituhr", "Kommt zahlreich", "kalle@revo.de")
        }

        fun curry36(): ListLocation = ListLocation("1", "Curry 36", "Mehringdamm", "36", 52.4935584, 13.3877282)

        fun cafeKotti(): ListLocation = ListLocation("1", "Café Kotti", "Adalbertstraße", "96", 52.5001477, 13.4181523)

        fun zukunft(): ListLocation = ListLocation("1", "Zukunft", "Laskerstraße", "5", 52.5016524, 13.4655402)

        fun sampleListLocations() = listOf(curry36(), cafeKotti(), zukunft())

    }
}