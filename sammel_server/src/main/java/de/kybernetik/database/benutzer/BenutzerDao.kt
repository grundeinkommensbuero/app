package de.kybernetik.database.benutzer

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
    }

    open fun getCredentials(id: Long): Credentials? {
        LOG.debug("Lade Credentials für Nutzer-ID $id")
        return entityManager.find(Credentials::class.java, id)
    }

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        if (benutzer.id != 0L) {
            throw NeuerBenutzerHatBereitsIdException()
        }
        LOG.debug("Neuen Benutzer anlegen " +
                if (benutzer.name.isNullOrBlank()) "ohne Namen" else "mit Name ${benutzer.name}")
        try {
            entityManager.persist(benutzer)
            return benutzer
        } catch (e: Exception) {
            throw BenutzerAnlegenGescheitertException("Beim Anlegen eines neuen Benutzers ist ein unerwartetes technisches Problem aufgetreten")
        }
    }

    open fun aktualisiereBenutzername(id: Long, name: String): Benutzer {
        val benutzerAusDb = entityManager.find(Benutzer::class.java, id)
        benutzerAusDb.name = name
        LOG.debug("Benutzername aktualisiert für ${benutzerAusDb.id} mit ${benutzerAusDb.name}")
        return benutzerAusDb
    }

    open fun legeNeueCredentialsAn(credentials: Credentials) {
        entityManager.persist(credentials)
    }

    open fun benutzernameExistiert(name: String): Boolean {
        LOG.debug("Ermittle ob Benutzer $name existiert")
        return entityManager
                .createQuery("select benutzer from Benutzer benutzer where benutzer.name = :name", Benutzer::class.java)
                .setParameter("name", name)
                .resultList
                .isNotEmpty()
    }

    open fun getFirebaseKeys(benutzerListe: List<Benutzer>): List<String> {
        LOG.debug("Sammle Firebase-Keys für Nutzer ${benutzerListe.map { it.id }}")
        return entityManager
                .createQuery("" +
                        "select creds.firebaseKey from Credentials creds " +
                        "where creds.id in (:ids) " +
                        "and creds.isFirebase = true", String::class.java)
                .setParameter("ids", benutzerListe.map { it.id })
                .resultList
    }

    open fun getBenutzerOhneFirebase(benutzerListe: List<Benutzer>): List<Benutzer> {
        LOG.debug("Sammle Benutzer ohne Firebase-Keys aus ${benutzerListe.map { it.id }}")
        return entityManager
                .createQuery("" +
                        "select benutzer from Benutzer benutzer, Credentials creds " +
                        "where benutzer.id in (:ids) " +
                        "and creds.id = benutzer.id " +
                        "and creds.isFirebase = false", Benutzer::class.java)
                .setParameter("ids", benutzerListe.map { it.id })
                .resultList
    }

    open fun gibNutzerNamedRolle(benutzer: Benutzer) {
        entityManager
            .createNativeQuery("insert into Roles (id, role) values (:id, :rolle)")
            .setParameter("id", benutzer.id)
            .setParameter("rolle", "named")
            .executeUpdate()
        LOG.debug("Benutzer ${benutzer.id} um Rolle 'named' erweitert")
    }

    class NeuerBenutzerHatBereitsIdException : Exception()
    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)
}
