package database.stammdaten

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class StammdatenDao() {
    private val LOG = Logger.getLogger(StammdatenDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getOrte(): List<Ort> {
        val orte = entityManager.createQuery("select orte from Ort orte", Ort::class.java).resultList
        if(orte.isEmpty()) {
            LOG.error("Stammdaten leer: Keine Orte in Datenbank gefunden")
        }
        return orte
    }
}