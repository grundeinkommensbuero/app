package database.stammdaten

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
    var lattitude: Double = 52.518611 // Berlin

    @Column
    var longitude: Double = 13.408333 // Berlin

    constructor()

    constructor(id: Int, bezirk: String, ort: String, lattitude: Double, longitude: Double) {
        this.id = id
        this.bezirk = bezirk
        this.ort = ort
        this.lattitude = lattitude
        this.longitude = longitude
    ***REMOVED***
***REMOVED***