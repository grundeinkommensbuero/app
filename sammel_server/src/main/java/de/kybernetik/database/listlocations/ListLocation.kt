package de.kybernetik.database.listlocations

import javax.persistence.*

@Entity
@Table(name = "points")
class ListLocation() {

    constructor(id: String?, name: String, strasse: String, nr: String, laengengrad: Double?, breitengrad: Double?) : this() {
        this.id = id
        this.name = name
        this.strasse = strasse
        this.nr = nr
        this.laengengrad = laengengrad
        this.breitengrad = breitengrad
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: String? = null

    @Column
    var name: String = ""

    @Column
    var strasse: String = ""

    @Column
    var nr: String = ""

    @Column
    var laengengrad: Double? = null

    @Column
    var breitengrad: Double? = null
}

