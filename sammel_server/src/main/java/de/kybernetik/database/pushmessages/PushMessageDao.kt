package de.kybernetik.database.pushmessages

import de.kybernetik.database.benutzer.Benutzer
import org.jboss.logging.Logger
import de.kybernetik.rest.PushMessageDto
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
        LOG.debug("Lade Push-Messages für Benutzer $id")
        val resultList = entityManager
                .createQuery("select m from PushMessages m where m.empfaenger = $id", PushMessage::class.java)
                .resultList
        LOG.debug("Folgende PushMessages geladen: ${resultList.map { it.id }}")
        return resultList
    }

    open fun speicherePushMessageFuerEmpfaenger(nachricht: PushMessageDto, teilnehmer: List<Benutzer>) {
        LOG.debug("Speichere Nachricht für Empfänger ohne Firebase ${teilnehmer.map { it.id }}")
        for (teili in teilnehmer) {
            entityManager.persist(PushMessage(teili, nachricht.data, nachricht.notification))
        }
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