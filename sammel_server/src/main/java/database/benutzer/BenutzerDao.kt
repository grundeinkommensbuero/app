package database.benutzer

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class BenutzerDao {
    private val LOG = Logger.getLogger(BenutzerDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getBenutzer(id: Long): Benutzer? {
        LOG.debug("Lade Benutzer für Nutzer-ID $id")
        return entityManager.find(Benutzer::class.java, id)
    ***REMOVED***

    open fun getCredentials(id: Long): Credentials? {
        LOG.debug("Lade Credentials für Nutzer-ID $id")
        return entityManager.find(Credentials::class.java, id)
    ***REMOVED***

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        if (benutzer.id != 0L) {
            throw NeuerBenutzerHatBereitsIdException()
        ***REMOVED***
        LOG.debug("Neuen Benutzer anlegen " +
                if (benutzer.name.isNullOrBlank()) "ohne Namen" else "mit Name ${benutzer.name***REMOVED***")
        try {
            entityManager.persist(benutzer)
            return benutzer
        ***REMOVED*** catch (e: Exception) {
            throw BenutzerAnlegenGescheitertException("Beim Anlegen eines neuen Benutzers ist ein unerwartetes technisches Problem aufgetreten")
        ***REMOVED***
    ***REMOVED***


    open fun legeNeueCredentialsAn(credentials: Credentials) {
        entityManager.persist(credentials)
    ***REMOVED***

    open fun benutzernameExistiert(name: String): Boolean {
        LOG.debug("Ermittle ob Benutzer ${name***REMOVED*** existiert")
        return entityManager
                .createQuery("select benutzer from Benutzer benutzer where benutzer.name = :name", Benutzer::class.java)
                .setParameter("name", name)
                .resultList
                .isNotEmpty()
    ***REMOVED***

    open fun getFirebaseKeys(benutzerListe: List<Benutzer>): List<String> {
        LOG.debug("Sammle Firebase-Keys für Nutzer ${benutzerListe.map { it.id ***REMOVED******REMOVED***")
        return entityManager
                .createQuery("select creds.firebaseKey from Credentials creds where creds.id in (:ids)", String::class.java)
                .setParameter("ids", benutzerListe.map { it.id ***REMOVED***)
                .resultList
    ***REMOVED***

    class NeuerBenutzerHatBereitsIdException : Exception()
    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)
***REMOVED***
