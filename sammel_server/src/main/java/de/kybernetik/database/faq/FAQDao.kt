package de.kybernetik.database.faq

import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import java.time.LocalDateTime
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.NoResultException
import javax.persistence.PersistenceContext

@Stateless
open class FAQDao {
    private val LOG = Logger.getLogger(TermineDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getAllFAQ(): List<FAQ> {
        val faqs = entityManager.createQuery("from FAQ", FAQ::class.java).resultList
        LOG.debug("${faqs.size} FAQ-Einträge gefunden: ${faqs.map { it.title }}")
        return faqs
    }

    open fun getFAQTimestamp(): LocalDateTime? {
        try {
            return entityManager.createQuery("from FAQTimestamp", FAQTimestamp::class.java).singleResult.timestamp
        } catch (e: NoResultException) {
            return null
        }
    }
}