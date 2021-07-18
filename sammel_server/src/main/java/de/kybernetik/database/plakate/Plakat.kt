package de.kybernetik.database.plakate

import java.io.Serializable
import javax.persistence.*

@Entity
@Table(name = "Plakate")
class Plakat: Serializable {

    @Suppress("unused") // Wichtig für JPA
    constructor() {
        latitude = 0.0
        longitude = 0.0
        adresse = ""
        user_id = 0
    }

    constructor(
        id: Long,
        latitude: Double,
        longitude: Double,
        adresse: String,
        user_id: Long
    ) {
        this.id = id
        this.latitude = latitude
        this.longitude = longitude
        this.adresse = adresse
        this.user_id = user_id
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var latitude: Double

    @Column
    var longitude: Double

    @Column
    var adresse: String

    @Column
    var user_id: Long
}