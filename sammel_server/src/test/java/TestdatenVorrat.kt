import database.stammdaten.Ort
import database.benutzer.Benutzer
import database.termine.Termin
import rest.TermineRestResource
import java.time.LocalDateTime

class TestdatenVorrat {
    companion object {
        fun nordkiez(): Ort {
            return Ort(1, "Friedrichshain-Kreuzberg", "Friedrichshain Nordkiez")
        ***REMOVED***

        fun treptowerPark(): Ort {
            return Ort(2, "Treptow-Köpenick", "Treptower Part")
        ***REMOVED***

        fun goerli(): Ort {
            return Ort(3, "Friedrichshain-Kreuzberg", "Görlitzer Park und Umgebung")
        ***REMOVED***

        fun sammeltermin(): String {
            return "Sammel-Termin"
        ***REMOVED***

        fun infoveranstaltung(): String {
            return "Info-Veranstaltung"
        ***REMOVED***

        fun karl(): Benutzer {
            return Benutzer(1, "Karl Marx", "Expropriation!", "123456789")
        ***REMOVED***

        fun rosa(): Benutzer {
            return Benutzer(1, "Rosa Luxemburg", "Ich bin, ich war ich, werde sein", null)
        ***REMOVED***

        fun terminOhneTeilnehmer(): Termin {
            return Termin(1,
                    LocalDateTime.of(2019, 10, 22, 16, 30, 0),
                    LocalDateTime.of(2019, 10, 22, 18, 0, 0),
                    nordkiez(),
                    sammeltermin(),
                    emptyList())
        ***REMOVED***

        fun terminMitTeilnehmer(): Termin {
            return Termin(2,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    goerli(),
                    sammeltermin(),
                    listOf(karl(), rosa()))
        ***REMOVED***

        fun terminDtoMitTeilnehmer(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTermin(terminMitTeilnehmer())
        ***REMOVED***

        fun terminDtoOhneTeilnehmer(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTermin(terminOhneTeilnehmer())
        ***REMOVED***
    ***REMOVED***
***REMOVED***