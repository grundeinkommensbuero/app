package de.kybernetik.database.vorbehalte

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class VorbehalteDao {
    private val LOG = Logger.getLogger(VorbehalteDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun erzeugeNeueVorbehalte(vorbehalte: Vorbehalte): Vorbehalte {
        LOG.debug("Speichere Vorbehalte ${vorbehalte.id***REMOVED***")
        entityManager.persist(vorbehalte)
        entityManager.flush()
        return vorbehalte
    ***REMOVED***
***REMOVED***