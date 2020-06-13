package database.benutzer

import javax.persistence.*

@Entity
@Table(name = "Benutzer")
class Benutzer() {

    constructor(id: Long, name: String) : this() {
        this.id = id
        this.name = name
    ***REMOVED***

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var name: String = ""
***REMOVED***

