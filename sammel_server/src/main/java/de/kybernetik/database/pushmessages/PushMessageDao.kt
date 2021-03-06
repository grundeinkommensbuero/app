package de.kybernetik.database.pushmessages

import de.kybernetik.database.benutzer.Benutzer
import org.jboss.logging.Logger
import de.kybernetik.rest.PushMessageDto
import de.kybernetik.rest.PushNotificationDto
import javax.ejb.Stateless
import javax.inject.Inject
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Stateless
open class PushMessageDao {
    private val LOG = Logger.getLogger(PushMessageDto::class.java)

    @Inject
    @PersistenceContext(unitName = "mariaDB")
    private lateinit var entityManager: EntityManager

    open fun ladeAllePushMessagesFuerBenutzer(id: Long?): List<PushMessage> {
        val resultList = entityManager
            .createQuery("select m from PushMessages m where m.empfaenger = $id", PushMessage::class.java)
            .resultList
        return resultList
    }

    open fun speicherePushMessageFuerEmpfaenger(
        notification: PushNotificationDto?,
        data: Map<String, String>?,
        teilnehmer: List<Benutzer>
    ) {
        LOG.debug("Speichere Nachricht für Empfänger ${teilnehmer.map { it.id }} in Datenbank")
        for (teili in teilnehmer) entityManager.persist(PushMessage(teili, data, notification))
        entityManager.flush()
    }

    open fun loeschePushMessages(nachrichten: List<PushMessage>) {
        nachrichten.forEach {
            val nachricht = entityManager.find(PushMessage::class.java, it.id)
            entityManager.remove(nachricht)
        }
        entityManager.flush()
    }
}