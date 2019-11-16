package database.termine

import org.jboss.logging.Logger
import rest.TermineFilter
import shared.toDate
import java.time.LocalDate
import java.time.format.DateTimeFormatter
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

    open fun erzeugeGetTermineQuery(filter: TermineFilter): TypedQuery<Termin> {
        val query = entityManager
                .createQuery("select termine from Termin termine" +
                        if (filter.typen.isNotEmpty()) " where termine.typ in (:typen)" else "" +
                                if (filter.tage.isNotEmpty()) " where DATE(termine.beginn) in (:tage)" else "" +
                                        if (filter.bis != null) " where TIME(termine.beginn) <= TIME(:bis)" else "" +
                                                if (filter.von != null) " where TIME(termine.beginn) >= TIME(:von)" else "" +
                                                        if (filter.orte.isNotEmpty()) " where termine.ort in (:orte)" else "",
                        Termin::class.java)
        if(filter.typen.isNotEmpty()) query.setParameter("typen", filter.typen)
        if(filter.tage.isNotEmpty()) query.setParameter("tage", filter.tage.map { it.toDate() })
        if(filter.von != null) query.setParameter("von", filter.von.atDate(LocalDate.now()))
        if(filter.bis != null) query.setParameter("bis", filter.bis.atDate(LocalDate.now()))
        if(filter.orte.isNotEmpty()) query.setParameter("orte", filter.orte.map { it.convertToOrt() })
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
}