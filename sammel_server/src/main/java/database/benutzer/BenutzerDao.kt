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
        return entityManager.find(Benutzer::class.java, id)
    }

    open fun getCredentials(id: Long): Credentials? {
        return entityManager.find(Credentials::class.java, id)
    }

    open fun legeNeuenBenutzerAn(benutzer: Benutzer): Benutzer {
        if (benutzer.id != 0L) {
            throw NeuerBenutzerHatBereitsIdException()
        }
        try {
            entityManager.persist(benutzer)
            return benutzer
        } catch (e: Exception) {
            throw BenutzerAnlegenGescheitertException("Beim Anlegen eines neuen Benutzers ist ein unerwartetes technisches Problem aufgetreten")
        }
    }


    open fun legeNeueCredentialsAn(credentials: Credentials) {
        entityManager.persist(credentials)
    }

    open fun benutzernameExistiert(name: String): Boolean {
        return entityManager
                .createQuery("select benutzer from Benutzer benutzer where benutzer.name = :name", Benutzer::class.java)
                .setParameter("name", name)
                .resultList
                .isNotEmpty()
    }

    class NeuerBenutzerHatBereitsIdException : Exception()
    class BenutzerAnlegenGescheitertException(message: String) : java.lang.Exception(message)
}
