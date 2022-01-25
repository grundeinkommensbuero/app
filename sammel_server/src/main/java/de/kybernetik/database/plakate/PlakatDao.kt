package de.kybernetik.database.plakate

import org.jboss.logging.Logger
import java.lang.IllegalArgumentException
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class PlakateDao {
    private val LOG = Logger.getLogger(PlakateDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun erstellePlakat(plakat: Plakat): Plakat {
        LOG.debug("Speichere neues Plakat in Datenbank")
        entityManager.persist(plakat)
        entityManager.flush()
        LOG.debug("ID von neu erstelltem Plakat: ${plakat.id}")
        return plakat
    }

    open fun ladePlakat(id: Long): Plakat? {
        LOG.trace("Lade einzelnes Plakat $id")
        try {
            return entityManager.find(Plakat::class.java, id)
        } catch (e: IllegalArgumentException) {
            LOG.error(e.message, e)
            return null
        }
    }

    open fun loeschePlakat(plakat: Plakat) {
        LOG.debug("Lösche Plakat ${plakat.id}, in ${plakat.adresse}")
        entityManager.remove(plakat)
    }

    open fun ladeAllePlakate(): List<Plakat> {
        LOG.trace("Lade alle Plakate")
        return entityManager.createQuery("from Plakat", Plakat::class.java).resultList
    }
}