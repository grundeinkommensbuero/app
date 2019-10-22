package database.termine

import database.stammdaten.Ort
import database.benutzer.Benutzer
import java.time.LocalDateTime
import javax.persistence.*

@Entity()
@Table(name = "Termine")
class Termin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    var beginn: LocalDateTime? = null

    @Column
    var ende: LocalDateTime? = null

    @ManyToOne
    @JoinColumn(name = "ort")
    var ort: Ort? = null

    @Column
    var typ: String? = null

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "Termin_Teilnehmer",
            joinColumns = [JoinColumn(name = "Termin", referencedColumnName = "id")],
            inverseJoinColumns = [JoinColumn(name = "Teilnehmer", referencedColumnName = "id")])
    var teilnehmer: List<Benutzer> = emptyList()

    constructor()

    constructor(id: Long, beginn: LocalDateTime, ende: LocalDateTime, ort: Ort, typ: String, teilnehmer: List<Benutzer>) {
        this.id = id
        this.beginn = beginn
        this.ende = ende
        this.ort = ort
        this.typ = typ
        this.teilnehmer = teilnehmer
    }
}