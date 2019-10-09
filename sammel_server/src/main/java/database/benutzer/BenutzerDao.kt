package database.benutzer

import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import kotlin.Exception

@Stateless
open class BenutzerDao {

    @Inject
    @PersistenceContext(unitName = "mysql")
    private lateinit var entityManager: EntityManager

    @Throws(BenutzerMehrfachVorhandenException::class)
    open fun getBenutzer(name: String): Benutzer? {
        val query = "select benutzer from Benutzer benutzer where benutzer.name = :name"
        val benutzerListe = entityManager
                .createQuery(query, Benutzer::class.java)
                .setParameter("name", name)
                .resultList
        if (benutzerListe.size > 1) {
            throw BenutzerMehrfachVorhandenException("Benutzer ${name} ist mehrfach vorhanden")
        }
        if (benutzerListe.size == 0) {
            return null
        }
        return benutzerListe.first()
    }

    class BenutzerMehrfachVorhandenException(message: String) : Exception(message)

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        entityManager.persist(benutzer)
        val benutzerAusDb = getBenutzer(benutzer.name)
        if (benutzerAusDb == null) {
            throw BenutzerAnlegenGescheitertException("Beim Anlegen des Benutzers ist ein Fehler aufgetreten")
        }
        return benutzerAusDb
    }

    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)

}
