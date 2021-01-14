package de.kybernetik.database.termine

import javax.persistence.*

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
    var teilnehmer: Long? = null

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

    @Column
    var ausgefallen: Boolean? = null

    @Suppress("unused")
    constructor()

    constructor(id: Long,
                termin_id: Long?,
                user_id: Long?,
                teilnehmer: Long?,
                unterschriften: Long?,
                bewertung: Long?,
                stunden: Double?,
                kommentar: String?,
                situation: String?,
                ausgefallen: Boolean?) {
        this.id = id
        this.termin_id = termin_id
        this.user_id = user_id
        this.unterschriften = unterschriften
        this.teilnehmer = teilnehmer
        this.stunden = stunden
        this.bewertung = bewertung
        this.kommentar = kommentar
        this.situation = situation
        this.ausgefallen = ausgefallen
    }
}