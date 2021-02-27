package de.kybernetik.services

import de.kybernetik.database.termine.TermineDao
import de.kybernetik.rest.TermineFilter
import de.kybernetik.rest.TermineRestResource.TerminDto
import de.kybernetik.rest.TermineRestResource.TerminDto.Companion.convertFromTerminWithoutDetails
import org.jboss.logging.Logger
import java.time.LocalDate
import java.time.temporal.ChronoUnit
import javax.ejb.*

@Singleton
@Suppress("unused")
open class NeueAktionenNotification {
    private val LOG = Logger.getLogger(NeueAktionenNotification::class.java)
    private val neueAktionen24h = ArrayList<TerminDto>() // Achtung: Vormerkungen überleben einen Serverneustart nicht!

    @EJB
    private lateinit var termineDao: TermineDao

    @EJB
    private lateinit var pushService: PushService

    @Schedule(hour = "18")
    @Suppress("unused")
    open fun dailyNeueAktionenNotification() {
        LOG.debug("Starte Job für tägliche Push-Nachrichten über neue Aktionen")
        try {
            LOG.debug("Neue Aktionen der letzte 24 Stunden: ${neueAktionen24h.map { it.id ***REMOVED******REMOVED***")
            for (kiez in neueAktionen24h.map { it.ort ***REMOVED***.distinct()) {
                val aktionenInKiez = neueAktionen24h.filter { it.ort == kiez ***REMOVED***
                pushService.pusheNeueAktionenNotification(aktionenInKiez, "${aktionenInKiez[0].ort***REMOVED***-täglich")
            ***REMOVED***
            neueAktionen24h.clear()

            LOG.debug("Job für tägliche Push-Nachrichten über neue Aktionen abgeschlossen")
        ***REMOVED*** catch (e: InterruptedException) {
            LOG.error("Fehler im täglichen Job für neue Aktionen", e)
        ***REMOVED***
    ***REMOVED***

    open fun merkeNeueAktion(aktion: TerminDto) {
        LOG.debug("Merke neue Aktion ${aktion.id***REMOVED*** vor")
        neueAktionen24h.add(aktion)
    ***REMOVED***

    @Schedule(dayOfWeek = "Wed", hour = "18")
    @Suppress("unused")
    open fun weeklyNeueAktionenNotification() {
        LOG.debug("Starte Job für wöchentliche Push-Nachrichten über neue Aktionen")
        try {
            val filter = TermineFilter(tage = (0L..14L).map { LocalDate.now().plus(it, ChronoUnit.DAYS) ***REMOVED***)
            val aktionen = termineDao.getTermine(filter, 0L)

            LOG.debug("Aktionen der nächsten 2 Wochen: ${aktionen.map { it.id ***REMOVED******REMOVED***")
            for (kiez in aktionen.map { it.ort ***REMOVED***.distinct()) {
                val aktionenInKiez = aktionen.filter { it.ort == kiez ***REMOVED***
                pushService.pusheNeueAktionenNotification(
                    aktionenInKiez.map(::convertFromTerminWithoutDetails),
                    "${aktionenInKiez[0].ort***REMOVED***-wöchentlich"
                )
            ***REMOVED***

            LOG.debug("Job für wöchentliche Push-Nachrichten über neue Aktionen abgeschlossen")
        ***REMOVED*** catch (e: InterruptedException) {
            LOG.error("Fehler im wöchentlichen Job für neue Aktionen", e)
        ***REMOVED***
    ***REMOVED***

***REMOVED***
