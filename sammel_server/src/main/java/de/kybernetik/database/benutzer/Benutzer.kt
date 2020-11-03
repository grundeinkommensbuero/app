package de.kybernetik.database.benutzer

import javax.persistence.*

@Entity
@Table(name = "Benutzer")
class Benutzer() {

    constructor(id: Long, name: String?, color: Long?) : this() {
        this.id = id
        this.name = name
        this.color = color
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var name: String? = null

    @Column
    var color: Long? = null
}

