package database.listlocations

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class ListLocationDao {
    private val LOG = Logger.getLogger(ListLocationDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getActiveListLocations(): List<ListLocation>? {
        LOG.debug("Ermittle Listenorte")
        val query = "from ListLocation where active = true"
        val listlocations = entityManager
                .createQuery(query, ListLocation::class.java)
                .resultList
        LOG.debug("Listenorte gefunden: ${listlocations***REMOVED***")
        return listlocations
    ***REMOVED***
***REMOVED***
