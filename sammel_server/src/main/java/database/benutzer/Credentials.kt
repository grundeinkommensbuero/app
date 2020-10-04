package database.benutzer

import javax.persistence.*
import javax.persistence.FetchType.EAGER

@Entity
@Table(name = "Credentials")
class Credentials() {

    @Id
    var id: Long = 0

    @Column
    var secret: String = ""

    @Column
    var salt: String = ""

    @Column
    var firebaseKey: String = ""

    @ElementCollection(fetch = EAGER)
    @CollectionTable(name = "Roles", joinColumns = [JoinColumn(name = "id")])
    @Column(name = "role")
    var roles: List<String> = emptyList()

    constructor(id: Long, secret: String, salt: String, firebaseKey: String) : this() {
        this.id = id
        this.secret = secret
        this.salt = salt
        this.firebaseKey = firebaseKey
    }
}