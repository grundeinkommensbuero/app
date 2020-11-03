package de.kybernetik.database.benutzer

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

    @Suppress("unused")
    @Column
    var iterations: Int = 10

    @Column
    var firebaseKey: String = ""

    @Column
    var isFirebase: Boolean = true

    @ElementCollection(fetch = EAGER)
    @CollectionTable(name = "Roles", joinColumns = [JoinColumn(name = "id")])
    @Column(name = "role")
    var roles: List<String> = emptyList()

    constructor(id: Long, secret: String, salt: String, pushKey: String, isFirebase: Boolean, roles: List<String>) : this() {
        this.id = id
        this.secret = secret
        this.salt = salt
        this.firebaseKey = pushKey
        this.isFirebase = isFirebase
        this.roles = roles
    ***REMOVED***
***REMOVED***