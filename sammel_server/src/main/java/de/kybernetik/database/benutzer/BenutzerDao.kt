package de.kybernetik.database.benutzer

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class BenutzerDao {
    private val _log = Logger.getLogger(BenutzerDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getBenutzer(id: Long): Benutzer? {
        _log.debug("Lade Benutzer für Nutzer-ID $id")
        return entityManager.find(Benutzer::class.java, id)
    ***REMOVED***

    open fun getCredentials(id: Long): Credentials? {
        _log.debug("Lade Credentials für Nutzer-ID $id")
        return entityManager.find(Credentials::class.java, id)
    ***REMOVED***

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        if (benutzer.id != 0L) {
            throw NeuerBenutzerHatBereitsIdException()
        ***REMOVED***
        _log.debug(
            "Neuen Benutzer anlegen " +
                    if (benutzer.name.isNullOrBlank()) "ohne Namen" else "mit Name ${benutzer.name***REMOVED***"
        )
        try {
            entityManager.persist(benutzer)
            return benutzer
        ***REMOVED*** catch (e: Exception) {
            throw BenutzerAnlegenGescheitertException("Beim Anlegen eines neuen Benutzers ist ein unerwartetes technisches Problem aufgetreten")
        ***REMOVED***
    ***REMOVED***

    open fun aktualisiereBenutzername(id: Long, name: String): Benutzer {
        val benutzerAusDb = entityManager.find(Benutzer::class.java, id)
        benutzerAusDb.name = name
        _log.debug("Benutzername aktualisiert für ${benutzerAusDb.id***REMOVED*** mit ${benutzerAusDb.name***REMOVED***")
        return benutzerAusDb
    ***REMOVED***

    open fun legeNeueCredentialsAn(credentials: Credentials) {
        entityManager.persist(credentials)
    ***REMOVED***

    open fun benutzernameExistiert(name: String): Boolean {
        _log.debug("Ermittle ob Benutzer $name existiert")
        return entityManager
            .createQuery("select benutzer from Benutzer benutzer where benutzer.name = :name", Benutzer::class.java)
            .setParameter("name", name)
            .resultList
            .isNotEmpty()
    ***REMOVED***

    open fun getFirebaseKeys(benutzerListe: List<Benutzer>): List<String> {
        _log.debug("Sammle Firebase-Keys für Nutzer ${benutzerListe.map { it.id ***REMOVED******REMOVED***")
        return entityManager
            .createQuery(
                "select creds.firebaseKey from Credentials creds " +
                        "where creds.id in (:ids) " +
                        "and creds.isFirebase = true", String::class.java
            )
            .setParameter("ids", benutzerListe.map { it.id ***REMOVED***)
            .resultList
    ***REMOVED***

    open fun getBenutzerOhneFirebase(benutzerListe: List<Benutzer>): List<Benutzer> {
        _log.debug("Sammle Benutzer ohne Firebase-Keys aus ${benutzerListe.map { it.id ***REMOVED******REMOVED***")
        return entityManager
            .createQuery(
                "select benutzer from Benutzer benutzer, Credentials creds " +
                        "where benutzer.id in (:ids) " +
                        "and creds.id = benutzer.id " +
                        "and creds.isFirebase = false", Benutzer::class.java
            )
            .setParameter("ids", benutzerListe.map { it.id ***REMOVED***)
            .resultList
    ***REMOVED***

    open fun gibNutzerNamedRolle(benutzer: Benutzer) {
        entityManager
            .createNativeQuery("insert into Roles (id, role) values (:id, :rolle)")
            .setParameter("id", benutzer.id)
            .setParameter("rolle", "named")
            .executeUpdate()
        _log.debug("Benutzer ${benutzer.id***REMOVED*** um Rolle 'named' erweitert")
    ***REMOVED***

    class NeuerBenutzerHatBereitsIdException : Exception()
    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)
***REMOVED***
