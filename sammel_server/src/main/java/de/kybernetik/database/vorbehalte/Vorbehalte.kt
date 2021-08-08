package de.kybernetik.database.vorbehalte

import java.time.LocalDate
import javax.persistence.*

@Entity
@Table(name = "Vorbehalte")
class Vorbehalte {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var benutzer: Long = 0

    @Column
    var vorbehalte: String? = null

    @Column
    var datum: LocalDate? = null

    @Column
    var ort: String? = null

    @Suppress("unused")
    constructor()

    constructor(
        id: Long,
        vorbehalte: String,
        benutzer: Long,
        datum: LocalDate,
        ort: String
    ) {
        this.id = id
        this.vorbehalte = vorbehalte
        this.benutzer = benutzer
        this.datum = datum
        this.ort = ort
    ***REMOVED***
***REMOVED***