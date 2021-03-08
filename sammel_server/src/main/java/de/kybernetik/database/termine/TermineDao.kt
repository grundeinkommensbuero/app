package de.kybernetik.database.termine

import de.kybernetik.database.DatabaseException
import de.kybernetik.database.benutzer.Benutzer
import org.jboss.logging.Logger
import de.kybernetik.rest.TermineFilter
import de.kybernetik.shared.toDate
import java.lang.System.getProperty
import java.time.LocalDate.now
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.TypedQuery

@Stateless
open class TermineDao {
    private val LOG = Logger.getLogger(TermineDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getTermine(filter: TermineFilter, benutzerId: Long?): List<Termin> {
        val ergebnisse = erzeugeGetTermineQuery(filter, benutzerId).resultList
        LOG.debug("Gefundene Aktionen: ${ergebnisse.map { it.id ***REMOVED******REMOVED***")
        return ergebnisse
    ***REMOVED***

    private val aktuellKlausel: String = "DATE(termine.ende) >= (:heute)"
    private val typenKlausel = "termine.typ in (:typen)"
    private val tageKlausel = "DATE(termine.beginn) in (:tage)"
    private val vonKlausel = "TIME(termine.beginn) >= TIME(:von)"
    private val bisKlausel = "TIME(termine.beginn) <= TIME(:bis)"
    private val orteKlausel = "termine.ort in (:orte)"
    private val nurEigeneKlausel = "(:benutzer) in elements(termine.teilnehmer)"
    private val immerEigeneKlausel =
        "((:benutzer) in elements(termine.teilnehmer) and DATE(termine.ende) > (:vor7Tagen))"

    @Suppress("JpaQueryApiInspection") // IDEA kriegt die Query nicht zusammen
    open fun erzeugeGetTermineQuery(filter: TermineFilter, benutzerId: Long?): TypedQuery<Termin> {
        val filterKlausel = mutableListOf<String>()
        if (benutzerId != null) filterKlausel.add(aktuellKlausel)
        if (!filter.typen.isNullOrEmpty()) filterKlausel.add(typenKlausel)
        if (!filter.tage.isNullOrEmpty()) filterKlausel.add(tageKlausel)
        if (filter.von != null) filterKlausel.add(vonKlausel)
        if (filter.bis != null) filterKlausel.add(bisKlausel)
        if (!filter.orte.isNullOrEmpty()) filterKlausel.add(orteKlausel)
        if (filter.nurEigene == true && benutzerId != null) filterKlausel.add(nurEigeneKlausel)

        var sql = "select termine from Termin termine"
        if (filterKlausel.isNotEmpty()) sql += " where " + filterKlausel.joinToString(" and ")

        if (filter.immerEigene == null || filter.immerEigene == true && benutzerId != null) sql += " or $immerEigeneKlausel"

        sql += " order by termine.beginn"
        val query = entityManager.createQuery(sql, Termin::class.java)
        query.maxResults = getProperty("de.kybernetik.max-actions").toInt()


        if (filterKlausel.contains(aktuellKlausel))
            query.setParameter("heute", now().toDate())
        if (sql.contains(immerEigeneKlausel))
            query.setParameter(
                "vor7Tagen", now()
                    .minusDays(getProperty("de.kybernetik.action-age").toLong()).toDate()
            )
        if (sql.contains(immerEigeneKlausel) || filterKlausel.contains(nurEigeneKlausel))
            query.setParameter("benutzer", Benutzer(benutzerId!!, null, 0L))
        if (filterKlausel.contains(typenKlausel)) query.setParameter("typen", filter.typen)
        if (filterKlausel.contains(tageKlausel)) query.setParameter("tage", filter.tage!!.map { it.toDate() ***REMOVED***)
        if (filterKlausel.contains(vonKlausel)) query.setParameter("von", filter.von!!.atDate(now()))
        if (filterKlausel.contains(bisKlausel)) query.setParameter("bis", filter.bis!!.atDate(now()))
        if (filterKlausel.contains(orteKlausel)) query.setParameter("orte", filter.orte)
        return query
    ***REMOVED***

    open fun getTermin(id: Long): Termin? {
        return entityManager.find(Termin::class.java, id)
    ***REMOVED***

    open fun aktualisiereTermin(termin: Termin): Termin {
        LOG.debug("Aktualisiere Aktion ${termin.id***REMOVED***")
        if (termin.id != termin.details?.termin_id) {
            throw DatenkonsistenzException("Termin und TerminDetails stimmen nicht überein")
        ***REMOVED***
        termin.details!!.termin = termin
        entityManager.merge(termin)
        entityManager.flush()
        return termin
    ***REMOVED***

    open fun speichereEvaluation(evaluation: Evaluation): Evaluation {
        entityManager.persist(evaluation)
        entityManager.flush()
        return evaluation
    ***REMOVED***

    open fun ladeAlleEvaluationen(): List<Evaluation> {
        LOG.debug("Lade alle Evaluationen aus Datenbank")
        val evaluationen = entityManager
            .createQuery("select e from Evaluation e", Evaluation::class.java)
            .resultList
        LOG.trace("Evaluationen gefunden: $evaluationen")
        return evaluationen
    ***REMOVED***

    open fun erstelleNeuenTermin(termin: Termin): Termin {
        termin.details!!.termin = termin
        LOG.debug("Speichere Aktion ${termin.id***REMOVED***")
        entityManager.persist(termin)
        entityManager.flush()
        return termin

    ***REMOVED***

    @Throws(DatabaseException::class)
    open fun loescheAktion(action: Termin) {
        val actionFromDb: Termin
        try {
            actionFromDb = entityManager.find(Termin::class.java, action.id)
        ***REMOVED*** catch (ignore: IllegalArgumentException) {
            throw DatabaseException("Die Aktion wurde nicht gefunden und kann daher nicht gelöscht werden")
        ***REMOVED***
        try {
            entityManager.remove(actionFromDb)
            entityManager.flush()
        ***REMOVED*** catch (ignore: Exception) {
            throw DatabaseException("Die Aktion wurde gefunden, kann aber aus technischen Gründen nicht gelöscht werden")
        ***REMOVED***
    ***REMOVED***

    open fun storeToken(actionId: Long, token: String) {
        entityManager.persist(Token(actionId, token))
    ***REMOVED***

    open fun loadToken(actionId: Long): Token? {
        return entityManager.find(Token::class.java, actionId)
    ***REMOVED***

    open fun deleteToken(token: Token) {
        // aus irgendeinem Grund funktioniert ein einfaches Remove hier nicht, sondern es muss geprüft werden
        // ob das Token vom EntityManager verwaltet wird und um ergänzt werden, bevor es gelöscht werden kann
        // Muss das bei anderen Lösch-Funktionen auch passieren?
        entityManager.remove(if (entityManager.contains(token)) token else entityManager.merge(token))
    ***REMOVED***
***REMOVED***

class DatenkonsistenzException(message: String?) : Exception(message)
