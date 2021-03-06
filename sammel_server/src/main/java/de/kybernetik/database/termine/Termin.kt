package de.kybernetik.database.termine

import de.kybernetik.database.benutzer.Benutzer
import java.time.LocalDateTime
import javax.persistence.*
import javax.persistence.CascadeType.*
import javax.persistence.FetchType.EAGER
import javax.persistence.FetchType.LAZY

@Entity
@Table(name = "Termine")
class Termin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var beginn: LocalDateTime? = null

    @Column
    var ende: LocalDateTime? = null

    @Column
    var ort: String? = null

    @Column
    var typ: String? = null

    @Column
    var latitude: Double? = null

    @Column
    var longitude: Double? = null

    @ManyToMany(fetch = EAGER)
    @JoinTable(name = "Termin_Teilnehmer",
            joinColumns = [JoinColumn(name = "Termin", referencedColumnName = "id")],
            inverseJoinColumns = [JoinColumn(name = "Teilnehmer", referencedColumnName = "id")])
    var teilnehmer: List<Benutzer> = emptyList()

    @OneToOne(cascade = [ALL], fetch = LAZY, mappedBy = "termin")
    @PrimaryKeyJoinColumn
    var details: TerminDetails? = null

    @Suppress("unused")
    constructor()

    constructor(id: Long,
                beginn: LocalDateTime?,
                ende: LocalDateTime?,
                ort: String?,
                typ: String?, teilnehmer: List<Benutzer>,
                latitude: Double?,
                longitude: Double?,
                details: TerminDetails?) {
        this.id = id
        this.beginn = beginn
        this.ende = ende
        this.ort = ort
        this.typ = typ
        this.latitude = latitude
        this.longitude = longitude
        this.details = details
        this.teilnehmer = teilnehmer
    }
}