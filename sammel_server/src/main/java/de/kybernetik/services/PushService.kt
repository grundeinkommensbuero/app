package de.kybernetik.services

import com.google.gson.GsonBuilder
import com.google.gson.JsonSyntaxException
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.rest.*
import de.kybernetik.rest.TermineRestResource.TerminDto
import org.jboss.logging.Logger
import java.net.URLEncoder
import java.security.SecureRandom
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec
import javax.ejb.EJB
import javax.ejb.Startup
import javax.ejb.Stateless

@Startup
@Stateless
open class PushService {
    @EJB
    private lateinit var firebase: FirebaseService

    @EJB
    private lateinit var pushDao: PushMessageDao

    @EJB
    private lateinit var benutzerDao: BenutzerDao

    private val GSON = GsonBuilder().create()
    private val KEY = SecretKeySpec(Base64.getDecoder().decode("vue8NkTYyN1e2OoHGcapLZWiCTC+13Eqk9gXBSq4azc="), "AES")
    private val secureRandom = SecureRandom()
    private val LOG = Logger.getLogger(PushService::class.java)

    open fun sendePushNachrichtAnEmpfaenger(nachricht: PushMessageDto, empfaenger: List<Benutzer>) {
        val firebaseKeys = benutzerDao.getFirebaseKeys(empfaenger)
        val benutzerOhneFirebase = benutzerDao.getBenutzerOhneFirebase(empfaenger)

        val verschluesselt = verschluessele(nachricht.data)
        if (firebaseKeys.isNotEmpty())
            firebase.sendePushNachrichtAnEmpfaenger(nachricht.notification, verschluesselt, firebaseKeys)
        if (benutzerOhneFirebase.isNotEmpty())
            pushDao.speicherePushMessageFuerEmpfaenger(nachricht.notification, verschluesselt, benutzerOhneFirebase)
    }

    open fun sendePushNachrichtAnTopic(nachricht: PushMessageDto, topic: String) {
        val verschluesselt = verschluessele(nachricht.data)
        firebase.sendePushNachrichtAnTopic(nachricht.notification, verschluesselt, topic)
        pushDao.sendePushNachrichtAnTopic(nachricht.notification, verschluesselt, topic)
    }

    open fun verschluessele(data: Map<String, Any?>?): Map<String, String>? {
        try {
            // Parse Daten
            if (data.isNullOrEmpty()) return emptyMap()
            val json = GSON.toJson(data)
            val bytes = json.toByteArray()

            val nonce: String
            val ciphertext: String
            synchronized(Cipher::class.java) {
                val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
                cipher.init(Cipher.ENCRYPT_MODE, KEY, secureRandom)
                nonce = Base64.getEncoder().encodeToString(cipher.iv)
                val verschluesselt = cipher.doFinal(bytes)

                ciphertext = Base64.getEncoder().encodeToString(verschluesselt)
            }
            LOG.debug("Verschlüssele $data zu $ciphertext mit Nonce $nonce")
            return mapOf("encrypted" to "AES", "payload" to ciphertext, "nonce" to nonce)
        } catch (e: JsonSyntaxException) {
            LOG.error("Serialisieren von Push-Nachricht gescheitert", e)
            return null
        }
    }

    open fun pusheNeueAktionenNotification(aktionen: List<TerminDto>, topic: String) {
        LOG.debug("Neue Aktionen als Push-Messages zu versenden: ${aktionen.map { it.id }}")
        if (aktionen.isNullOrEmpty()) return

        if(aktionen.map { it.ort }.distinct().size > 1)
            LOG.warn("Orte aus unterschiedlichen Aktionen in derselben Push-Nachricht")

        val title = if (aktionen.size == 1) "Neue Aktion in deinem Kiez" else "Neue Aktionen in deinem Kiez"
        val body = if (aktionen.size == 1)
            "${aktionen[0].typ} am ${aktionen[0].beginn!!.format(DateTimeFormatter.ofPattern("dd.MM. 'um' HH:mm 'Uhr'"))}, ${aktionen[0].ort}"
        else
            "${aktionen.size} neue Aktionen in ${aktionen[0].ort}"

        val pushMessage = PushMessageDto(
            PushNotificationDto(title, body, "Aktionen im Kiez"),
            mapOf<String, Any>(
                "type" to "NewKiezActions",
                "channel" to "kiez:new_action",
                "timestamp" to ZonedDateTime.now().format(DateTimeFormatter.ISO_OFFSET_DATE_TIME),
                "actions" to aktionen
            )
        )
        val topicEnc = URLEncoder.encode(topic, Charsets.UTF_8.name()).replace("+", "%20")
        sendePushNachrichtAnTopic(pushMessage, topicEnc)
    }

}