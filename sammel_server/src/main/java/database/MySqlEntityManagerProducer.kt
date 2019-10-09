package database

import javax.enterprise.context.ApplicationScoped
import javax.enterprise.inject.Produces
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@ApplicationScoped
class MySqlEntityManagerProducer {
    @PersistenceContext(unitName = "mysql")
    private lateinit var entityManager: EntityManager

    @Produces
    fun entityManager(): EntityManager {
        return entityManager
    }
}