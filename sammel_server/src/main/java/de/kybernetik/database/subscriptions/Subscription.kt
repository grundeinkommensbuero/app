package de.kybernetik.database.subscriptions

import java.io.Serializable
import javax.persistence.*


@Entity(name = "Subscriptions")
@IdClass(SubscriptionKey::class)
class Subscription {

    @Suppress("unused") // für JPA
    constructor()

    constructor(benutzer: Long, topic: String) {
        this.benutzer = benutzer
        this.topic = topic
    }

    @Id
    var benutzer: Long = 0

    @Id
    lateinit var topic: String
}

@Suppress("unused") // für JPA
class SubscriptionKey(private var benutzer: Long = 0, private var topic: String) : Serializable {
    constructor() : this(0,"")
}