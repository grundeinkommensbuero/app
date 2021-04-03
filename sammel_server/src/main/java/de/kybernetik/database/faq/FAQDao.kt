package de.kybernetik.database.faq

import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class FAQDao {
    private val LOG = Logger.getLogger(TermineDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getAllFAQ(): List<FAQ> {
        val faqs = entityManager.createQuery("from FAQ", FAQ::class.java).resultList
        LOG.debug("${faqs.size***REMOVED*** FAQ-Einträge gefunden: ${faqs.map { it.titel ***REMOVED******REMOVED***")
        return faqs
    ***REMOVED***
***REMOVED***