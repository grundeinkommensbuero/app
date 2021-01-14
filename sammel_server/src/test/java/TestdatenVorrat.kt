import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.listlocations.ListLocation
import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TerminDetails
import de.kybernetik.rest.TermineRestResource
import java.time.LocalDateTime

class TestdatenVorrat {
    companion object {
        fun sammeltermin(): String {
            return "Sammeln"
        ***REMOVED***

        fun infoveranstaltung(): String {
            return "Infoveranstaltung"
        ***REMOVED***

        fun karl(): Benutzer {
            return Benutzer(11, "Karl Marx", 4294198070)
        ***REMOVED***

        fun rosa(): Benutzer {
            return Benutzer(12, "Rosa Luxemburg", 0)
        ***REMOVED***

        fun bini(): Benutzer {
            return Benutzer(13, "Bini Adamczak", 3L)
        ***REMOVED***

        fun terminOhneTeilnehmerOhneDetails(): Termin {
            return Termin(1L,
                    LocalDateTime.of(2019, 10, 22, 16, 30, 0),
                    LocalDateTime.of(2019, 10, 22, 18, 0, 0),
                    "Frankfurter Allee Nord",
                    sammeltermin(),
                    emptyList(),
                    52.48612,
                    13.47192,
                    null)
        ***REMOVED***

        fun terminMitTeilnehmerOhneDetails(): Termin {
            return Termin(2L,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                    "Tempelhofer Vorstadt",
                    sammeltermin(),
                    listOf(karl(), rosa()),
                    52.48612,
                    13.47192,
                    null)
        ***REMOVED***

        fun terminMitTeilnehmerMitDetails(): Termin {
            return Termin(2L,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                "Tempelhofer Vorstadt",
                    sammeltermin(),
                    listOf(karl(), rosa()),
                    52.48612,
                    13.47192,
                    terminDetails())
        ***REMOVED***

        fun terminOhneTeilnehmerMitDetails(): Termin {
            return Termin(2L,
                    LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                    LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                "Tempelhofer Vorstadt",
                    sammeltermin(),
                    emptyList(),
                    52.48612,
                    13.47192,
                    terminDetails())
        ***REMOVED***

        fun terminDto(): TermineRestResource.TerminDto {
            return TermineRestResource.TerminDto.convertFromTerminWithoutDetails(terminOhneTeilnehmerOhneDetails())
        ***REMOVED***

        internal fun terminDetails(): TerminDetails {
            return TerminDetails(1, "Weltzeituhr", "Kommt zahlreich", "kalle@revo.de")
        ***REMOVED***

        fun curry36(): ListLocation = ListLocation("1", "Curry 36", "Mehringdamm", "36", 52.4935584, 13.3877282)

        fun cafeKotti(): ListLocation = ListLocation("1", "Café Kotti", "Adalbertstraße", "96", 52.5001477, 13.4181523)

        fun zukunft(): ListLocation = ListLocation("1", "Zukunft", "Laskerstraße", "5", 52.5016524, 13.4655402)

        fun sampleListLocations() = listOf(curry36(), cafeKotti(), zukunft())

    ***REMOVED***
***REMOVED***