import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.besuchteshaus.BesuchtesHaus
import de.kybernetik.database.listlocations.ListLocation
import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TerminDetails
import de.kybernetik.rest.TermineRestResource
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalDateTime.now

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
            return Termin(
                1L,
                LocalDateTime.of(2019, 10, 22, 16, 30, 0),
                LocalDateTime.of(2019, 10, 22, 18, 0, 0),
                "Frankfurter Allee Nord",
                sammeltermin(),
                emptyList(),
                52.48612,
                13.47192,
                null
            )
        ***REMOVED***

        fun terminMitTeilnehmerOhneDetails(): Termin {
            return Termin(
                2L,
                LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                "Tempelhofer Vorstadt",
                sammeltermin(),
                listOf(karl(), rosa()),
                52.48612,
                13.47192,
                null
            )
        ***REMOVED***

        fun terminMitTeilnehmerMitDetails(): Termin {
            return Termin(
                2L,
                LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                "Tempelhofer Vorstadt",
                sammeltermin(),
                listOf(karl(), rosa()),
                52.48612,
                13.47192,
                terminDetails()
            )
        ***REMOVED***

        fun terminOhneTeilnehmerMitDetails(): Termin {
            return Termin(
                2L,
                LocalDateTime.of(2019, 10, 22, 12, 0, 0),
                LocalDateTime.of(2019, 10, 22, 15, 0, 0),
                "Tempelhofer Vorstadt",
                sammeltermin(),
                emptyList(),
                52.48612,
                13.47192,
                terminDetails()
            )
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

        fun kanzlerinamt() = BesuchtesHaus(1, 52.52014, 13.36911, "Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557", "Westflügel", LocalDate.of(2021,7,18), 11)

        fun hausundgrund() = BesuchtesHaus(2,  52.4964133, 13.3617511, "Potsdamer Straße 143, 10783 Berlin", null, LocalDate.of(2021,7,17), 12)

        fun konradadenauerhaus() = BesuchtesHaus(3, 52.5065, 13.35125, "Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785", "Haupteingang", LocalDate.of(2021,7,19), 11)
    ***REMOVED***

    @Suppress("unused")
    open class TerminBuilder {
        val termin = terminOhneTeilnehmerOhneDetails()

        open fun mitTeilnehmern(): TerminBuilder {
            termin.teilnehmer = terminMitTeilnehmerOhneDetails().teilnehmer
            return this
        ***REMOVED***

        open fun mitDetails(): TerminBuilder {
            termin.details = terminMitTeilnehmerMitDetails().details
            return this
        ***REMOVED***

        open fun heute(): TerminBuilder {
            termin.beginn = now().plusHours(1)
            termin.ende = now().plusHours(3)
            return this
        ***REMOVED***

        open fun mitKoordinaten(latitude: Double?, longitude: Double?): TerminBuilder {
            termin.latitude = latitude
            termin.longitude = longitude
            return this
        ***REMOVED***

        open fun build(): Termin {
            return termin
        ***REMOVED***
    ***REMOVED***
***REMOVED***