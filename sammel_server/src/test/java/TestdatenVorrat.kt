import database.stammdaten.Ort
import database.benutzer.Benutzer

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
    }
}