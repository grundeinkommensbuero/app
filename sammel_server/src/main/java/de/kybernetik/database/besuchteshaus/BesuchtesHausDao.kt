package de.kybernetik.database.besuchteshaus

import org.jboss.logging.Logger
import java.lang.IllegalArgumentException
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class BesuchtesHausDao {
    private val LOG = Logger.getLogger(BesuchtesHausDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun erstelleBesuchtesHaus(besuchtesHaus: BesuchtesHaus): BesuchtesHaus {
        LOG.debug("Speichere neues HausBesucht in Datenbank")
        entityManager.persist(besuchtesHaus)
        entityManager.flush()
        LOG.debug("ID von neu erstelltem HausBesucht: ${besuchtesHaus.id}")
        return besuchtesHaus
    }

    open fun ladeBesuchtesHaus(id: Long): BesuchtesHaus? {
        LOG.trace("Lade einzelnes Besuchtes Haus $id")
        try {
            return entityManager.find(BesuchtesHaus::class.java, id)
        } catch (e: IllegalArgumentException) {
            LOG.error(e.message, e)
            return null
        }
    }

    open fun loescheBesuchtesHaus(besuchtesHaus: BesuchtesHaus) {
        LOG.debug("Lösche Besuchtes Haus ${besuchtesHaus.id}, in ${besuchtesHaus.adresse}")
        entityManager.remove(besuchtesHaus)
    }

    open fun ladeAlleBesuchtenHaeuser(): List<BesuchtesHaus> {
        LOG.trace("Lade alle Besuchten Häuser")
        return entityManager.createQuery("from BesuchtesHaus", BesuchtesHaus::class.java).resultList
    }
}