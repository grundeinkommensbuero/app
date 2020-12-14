package de.kybernetik.database.pushmessages

import org.apache.commons.lang3.SerializationUtils
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.rest.PushNotificationDto
import javax.persistence.*

@Entity(name = "PushMessages")
class PushMessage {

    @Suppress("unused") // für JPA
    constructor()

    constructor(empfaenger: Benutzer, daten: Map<String, Any?>?, benachrichtigung: PushNotificationDto?) {
        this.empfaenger = empfaenger
        if (daten != null) this.daten = SerializationUtils.serialize(HashMap(daten))
        if (benachrichtigung != null) this.benachrichtigung = SerializationUtils.serialize(benachrichtigung)
    ***REMOVED***

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @JoinColumn(name = "empfaenger")
    @ManyToOne
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