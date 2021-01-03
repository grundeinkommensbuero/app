package de.kybernetik.database.subscriptions

import org.jboss.logging.Logger
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class SubscriptionDao {
    private val LOG = Logger.getLogger(SubscriptionDao::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun getSubscribersForTopic(topic: String): List<Long> {
        LOG.debug("Ermittle Subscriber für Topic $topic")
        val subscriber = entityManager
            .createQuery("from Subscriptions where topic = :topic", Subscription::class.java)
            .setParameter("topic", topic)
            .resultList
            ?.map { it.benutzer } ?: emptyList()

        LOG.debug("Subscriber gefunden: $subscriber}")
        return subscriber
    }

    open fun subscribe(benutzerId: Long, topics: List<String>) {
        LOG.debug("Subscribe Benutzer $benutzerId an Topics $topics")
        for (topic in topics) entityManager.merge(Subscription(benutzerId, topic))
    }

    open fun unsubscribe(benutzerId: Long, topics: List<String>) {
        LOG.debug("Unsubscribe Benutzer $benutzerId von Topics $topics")
        for (topic in topics) {
            val subscription = entityManager.find(Subscription::class.java, SubscriptionKey(benutzerId, topic))
            if (subscription != null) entityManager.remove(subscription)
        }
    }
}