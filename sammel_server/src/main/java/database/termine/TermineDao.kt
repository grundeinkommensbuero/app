package database.termine

import database.DatabaseException
import org.jboss.logging.Logger
import rest.TermineFilter
import shared.toDate
import java.time.LocalDate
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.TypedQuery

@Stateless
open class TermineDao {
    private val LOG = Logger.getLogger(TermineDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mysql")
    private lateinit var entityManager: EntityManager

    open fun getTermine(filter: TermineFilter): List<Termin> {
        return erzeugeGetTermineQuery(filter).resultList
    }

    private val typenKlausel = "termine.typ in (:typen)"
    private val tageKlausel = "DATE(termine.beginn) in (:tage)"
    private val vonKlausel = "TIME(termine.beginn) >= TIME(:von)"
    private val bisKlausel = "TIME(termine.beginn) <= TIME(:bis)"
    private val orteKlausel = "termine.ort in (:orte)"

    @Suppress("JpaQueryApiInspection") // IDEA kriegt die Query nicht zusammen
    open fun erzeugeGetTermineQuery(filter: TermineFilter): TypedQuery<Termin> {
        val filterKlausel = mutableListOf<String>()
        if (filter.typen.isNotEmpty()) filterKlausel.add(typenKlausel)
        if (filter.tage.isNotEmpty()) filterKlausel.add(tageKlausel)
        if (filter.von != null) filterKlausel.add(vonKlausel)
        if (filter.bis != null) filterKlausel.add(bisKlausel)
        if (filter.orte.isNotEmpty()) filterKlausel.add(orteKlausel)

        var sql = "select termine from Termin termine"
        if (filterKlausel.isNotEmpty()) sql += " where " + filterKlausel.joinToString(" and ")
        val query = entityManager.createQuery(sql, Termin::class.java)

        if (filterKlausel.contains(typenKlausel)) query.setParameter("typen", filter.typen)
        if (filterKlausel.contains(tageKlausel)) query.setParameter("tage", filter.tage.map { it.toDate() })
        if (filterKlausel.contains(vonKlausel)) query.setParameter("von", filter.von!!.atDate(LocalDate.now()))
        if (filterKlausel.contains(bisKlausel)) query.setParameter("bis", filter.bis!!.atDate(LocalDate.now()))
        if (filterKlausel.contains(orteKlausel)) query.setParameter("orte", filter.orte.map { it.convertToOrt() })
        LOG.debug("debug ### " + query.toString())
        return query
    }

    open fun getTermin(id: Long): Termin {
        return entityManager.find(Termin::class.java, id)
    }

    open fun aktualisiereTermin(termin: Termin): Termin {
        entityManager.merge(termin)
        entityManager.flush()
        return termin
    }

    open fun erstelleNeuenTermin(termin: Termin): Termin {
        entityManager.persist(termin)
        entityManager.flush()
        return termin

    }

    @Throws(DatabaseException::class)
    open fun deleteAction(action: Termin) {
        val actionFromDb: Termin
        try {
            actionFromDb = entityManager.find(Termin::class.java, action.id)
        } catch (ignore: IllegalArgumentException) {
            throw DatabaseException("Die Aktion wurde nicht gefunden und kann daher nicht gelöscht werden")
        }
        try {
            entityManager.remove(actionFromDb)
            entityManager.flush()
        } catch (ignore: Exception) {
            throw DatabaseException("Die Aktion wurde gefunden, kann aber aus technischen Gründen nicht gelöscht werden")
        }
    }
}