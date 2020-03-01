package database.benutzer

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import kotlin.Exception

@Stateless
open class BenutzerDao {
    private val LOG = Logger.getLogger(BenutzerDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    @Throws(BenutzerMehrfachVorhandenException::class)
    open fun getBenutzer(name: String): Benutzer? {
        val query = "select benutzer from Benutzer benutzer where benutzer.name = :name"
        val benutzerListe = entityManager
                .createQuery(query, Benutzer::class.java)
                .setParameter("name", name)
                .resultList
        if (benutzerListe.size > 1) {
            val message = "Benutzer $name ist mehrfach vorhanden"
            LOG.warn("Inkonsistente Daten in der Datenbank: $message")
            throw BenutzerMehrfachVorhandenException(message)
        ***REMOVED***
        if (benutzerListe.size == 0) {
            return null
        ***REMOVED***
        return benutzerListe.first()
    ***REMOVED***

    class BenutzerMehrfachVorhandenException(message: String) : Exception(message)

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        entityManager.persist(benutzer)
        val benutzerAusDb = getBenutzer(benutzer.name)
        if (benutzerAusDb == null) {
            LOG.warn("Benutzer ${benutzer.name***REMOVED*** (${benutzer.id***REMOVED***) wurde fehlerfrei in Datenbank angelegt aber nicht wieder gefunden")
            throw BenutzerAnlegenGescheitertException("Beim Anlegen des Benutzers ist ein Fehler aufgetreten")
        ***REMOVED***
        return benutzerAusDb
    ***REMOVED***

    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)

***REMOVED***
