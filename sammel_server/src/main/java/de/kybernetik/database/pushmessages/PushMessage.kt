package de.kybernetik.database.pushmessages

import org.apache.commons.lang3.SerializationUtils
import org.jboss.logging.Logger
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.rest.PushNotificationDto
import javax.persistence.*
import javax.persistence.CascadeType.REMOVE
import kotlin.jvm.Transient

@Entity(name = "PushMessages")
class PushMessage {
    @Transient
    private val LOG = Logger.getLogger(PushMessage::class.java)

    @Suppress("unused") // für JPA
    constructor()

    constructor(empfaenger: Benutzer, daten: Map<String, String>?, benachrichtigung: PushNotificationDto?) {
        this.empfaenger = empfaenger
        if (daten != null) this.daten = SerializationUtils.serialize(HashMap(daten))
        if (benachrichtigung != null) this.benachrichtigung = SerializationUtils.serialize(benachrichtigung)
    ***REMOVED***

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @JoinColumn(name = "empfaenger")
    @ManyToOne(cascade = [REMOVE])
    lateinit var empfaenger: Benutzer

    @Column
    @Lob
    var daten: ByteArray? = null

    @Column
    @Lob
    var benachrichtigung: ByteArray? = null

    fun getDaten(): HashMap<String, String>? {
        if (daten == null) return null
        else return SerializationUtils.deserialize<HashMap<String, String>>(daten)
    ***REMOVED***

    fun getBenachrichtigung(): PushNotificationDto? {
        if (benachrichtigung == null) return null
        else return SerializationUtils.deserialize(benachrichtigung)
    ***REMOVED***
***REMOVED***