package de.kybernetik.database.besuchteshaus

import java.io.Serializable
import java.time.LocalDate
import javax.persistence.*

@Entity
@Table(name = "BesuchteHaeuser")
class BesuchtesHaus: Serializable {

    @Suppress("unused") // Wichtig für JPA
    constructor() {
        latitude = 0.0
        longitude = 0.0
        adresse = ""
        datum = LocalDate.MIN
        user_id = 0
    ***REMOVED***

    constructor(
        id: Long,
        latitude: Double,
        longitude: Double,
        adresse: String,
        hausteil: String?,
        polygon: String?,
        osmId: Long?,
        datum: LocalDate,
        user_id: Long
    ) {
        this.id = id
        this.latitude = latitude
        this.longitude = longitude
        this.adresse = adresse
        this.hausteil = hausteil
        this.polygon = polygon
        this.osm_id = osmId
        this.datum = datum
        this.user_id = user_id
    ***REMOVED***

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
    var hausteil: String? = null

    @Column
    var polygon: String? = null

    @Column
    var osm_id: Long? = null

    @Column
    var datum: LocalDate

    @Column
    var user_id: Long
***REMOVED***