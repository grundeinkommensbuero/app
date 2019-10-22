package database.benutzer

import javax.persistence.*

@Entity
@Table(name = "Benutzer")
class Benutzer() {

    constructor(id: Long, name: String, passwort: String, telefonnummer: String?) : this() {
        this.id = id
        this.name = name
        this.telefonnummer = telefonnummer
        this.passwort = passwort
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var name: String = ""

    @Column
    var passwort: String = ""

    @Column
    var telefonnummer: String? = null
}

