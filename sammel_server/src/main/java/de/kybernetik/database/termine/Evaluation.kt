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
    var terminId: Long? = null

    @Column
    var unterschriften: Long? = null

    @Column
    var teilnehmende: Long? = null

    @Column
    var stunden: Double? = null

    @Column
    var kommentar: String? = null

    @Column
    var erkenntnisse: String? = null

    @Suppress("unused")
    constructor()

    constructor(id: Long,
                terminId: Long?,
                unterschriften: Long?,
                teilnehmende: Long?,
                stunden: Double?,
                kommentar: String?,
                erkenntnisse: String?) {
        this.id = id
        this.terminId = terminId
        this.unterschriften = unterschriften
        this.stunden = stunden
        this.teilnehmende = teilnehmende
        this.kommentar = kommentar
        this.erkenntnisse = erkenntnisse
    ***REMOVED***
***REMOVED***