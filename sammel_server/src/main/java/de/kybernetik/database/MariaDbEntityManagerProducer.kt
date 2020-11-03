package de.kybernetik.database

import javax.enterprise.context.ApplicationScoped
import javax.enterprise.inject.Produces
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@ApplicationScoped
class MariaDbEntityManagerProducer {
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    @Produces
    fun entityManager(): EntityManager {
        return entityManager
    }
}