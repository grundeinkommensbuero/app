package database.listlocations

import javax.persistence.*

@Entity
@Table(name = "points")
class ListLocation() {

    constructor(id: Long, name: String, strasse: String, nummer: String?, latitude: Double?, longitude: Double?) : this() {
        this.id = id
        this.name = name
        this.strasse = strasse
        this.nummer = nummer
        this.latitude = latitude
        this.longitude = longitude
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var name: String = ""

    @Column
    var strasse: String = ""

    @Column
    var nummer: String? = null

    @Column
    var latitude: Double? = null

    @Column
    var longitude: Double? = null
}

