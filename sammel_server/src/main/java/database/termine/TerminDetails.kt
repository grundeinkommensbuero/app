package database.termine

import javax.persistence.*
import javax.persistence.CascadeType.ALL

@Entity
@Table(name = "TerminDetails")
class TerminDetails {

    @Id
    @Column(name = "termin_id")
    var termin_id: Long? = null

    @OneToOne(cascade = [ALL])
    @MapsId
    @JoinColumn(name = "termin_id")
    var termin: Termin? = null

    @Column
    var treffpunkt: String? = null

    @Column
    var kommentar: String? = null

    @Column
    var kontakt: String? = null

    constructor()

    constructor(termin_id: Long?, treffpunkt: String?, kommentar: String?, kontakt: String?) {
        this.termin_id = termin_id
        this.treffpunkt = treffpunkt
        this.kommentar = kommentar
        this.kontakt = kontakt
    ***REMOVED***
***REMOVED***