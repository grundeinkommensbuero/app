package de.kybernetik.database.termine

import de.kybernetik.database.stammdaten.Ort
import de.kybernetik.database.benutzer.Benutzer
import java.time.LocalDateTime
import javax.persistence.*
import javax.persistence.CascadeType.*
import javax.persistence.FetchType.EAGER
import javax.persistence.FetchType.LAZY

@Entity
@Table(name = "Evaluationen")
class Evaluation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var termin_id: Long? = null

    @Column
    var user_id: Long? = null

    @Column
    var unterschriften: Long? = null

    @Column
    var bewertung: Long? = null

    @Column
    var stunden: Double? = null

    @Column
    var kommentar: String? = null

    @Column
    var situation: String? = null

    @Suppress("unused")
    constructor()

    constructor(id: Long,
                termin_id: Long?,
                user_id: Long?,
                unterschriften: Long?,
                bewertung: Long?,
                stunden: Double?,
                kommentar: String?,
                situation: String?) {
        this.id = id
        this.termin_id = termin_id
        this.user_id = user_id
        this.unterschriften = unterschriften
        this.stunden = stunden
        this.bewertung = bewertung
        this.kommentar = kommentar
        this.situation = situation
    ***REMOVED***
***REMOVED***