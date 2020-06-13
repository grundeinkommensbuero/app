package database.benutzer

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

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

    constructor(id: Long, secret: String, salt: String, firebaseKey: String) : this() {
        this.id = id
        this.secret = secret
        this.salt = salt
        this.firebaseKey = firebaseKey
    ***REMOVED***
***REMOVED***