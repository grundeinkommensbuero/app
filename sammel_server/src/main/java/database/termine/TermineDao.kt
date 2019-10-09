package database.termine

import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class TermineDao {

    @Inject
    @PersistenceContext(unitName = "mysql")
    private lateinit var entityManager: EntityManager

    open fun getTermine(): List<Termin> {
        return entityManager
                .createQuery("select termine from Termin termine", Termin::class.java)
                .resultList
    ***REMOVED***

    open fun getTermin(id: Long): Termin {
        return entityManager.find(Termin::class.java, id)
    ***REMOVED***

    open fun aktualisiereTermin(termin: Termin): Termin {
        entityManager.merge(termin)
        entityManager.flush()
        return termin
    ***REMOVED***

    open fun erstelleNeuenTermin(termin: Termin): Termin {
        entityManager.persist(termin)
        entityManager.flush()
        return termin

    ***REMOVED***
***REMOVED***