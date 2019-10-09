package database.Stammdaten

import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class StammdatenDao() {

    @Inject
    @PersistenceContext(unitName = "mysql")
    private lateinit var entityManager: EntityManager

    open fun getOrte(): List<Ort> {
        return entityManager.createQuery("select orte from Ort orte", Ort::class.java).resultList
    }
}