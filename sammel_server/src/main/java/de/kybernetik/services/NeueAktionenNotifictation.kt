package de.kybernetik.services

import de.kybernetik.database.termine.TermineDao
import de.kybernetik.rest.TermineFilter
import de.kybernetik.rest.TermineRestResource.TerminDto.Companion.convertFromTerminWithDetails
import org.jboss.logging.Logger
import java.time.LocalDate
import java.time.temporal.ChronoUnit
import javax.ejb.*

@Singleton
@Suppress("unused")
open class NeueAktionenNotification {
    private val LOG = Logger.getLogger(NeueAktionenNotification::class.java)

    @EJB
    private lateinit var termineDao: TermineDao

    @EJB
    private lateinit var pushService: PushService

    @Schedule(second = "0,20,40", minute = "*", hour = "*"/*dayOfWeek = "Wed", hour = "18"*/)
    @Suppress("unused")
    open fun weeklyNeueAktionenNotification() {
        LOG.debug("Starte Job für wöchentliche Push-Nachrichten über neue Aktionen")
        try {
            val filter = TermineFilter(tage = (0L..14L).map { LocalDate.now().plus(it, ChronoUnit.DAYS) })
            val aktionen = termineDao.getTermine(filter)

            LOG.debug("Aktionen der nächsten 2 Wochen: ${aktionen.map { it.id }}")
            for (kiez in aktionen.map { it.ort }.distinct()) {
                val aktionenInKiez = aktionen.filter { it.ort == kiez }
                pushService.pusheNeueAktionenNotification(aktionenInKiez.map(::convertFromTerminWithDetails))
            }

            LOG.debug("Job für wöchentliche Push-Nachrichten über neue Aktionen abgeschlossen")
        } catch (e: InterruptedException) {
            LOG.error("Fehler im wöchentlichen Job für neue Aktionen", e)
        }
    }

}
