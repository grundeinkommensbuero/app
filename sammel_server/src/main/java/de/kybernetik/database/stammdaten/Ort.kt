package de.kybernetik.database.stammdaten

import javax.persistence.*

@Entity
@Table(name = "Stamm_Orte")
class Ort {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int = 0

    @Column
    var bezirk: String = ""

    @Column
    var ort: String = ""

    @Column
    var latitude: Double? = null

    @Column
    var longitude: Double? = null

    constructor()

    constructor(id: Int, bezirk: String, ort: String, latitude: Double?, longitude: Double?) {
        this.id = id
        this.bezirk = bezirk
        this.ort = ort
        this.latitude = latitude
        this.longitude = longitude
    }
}