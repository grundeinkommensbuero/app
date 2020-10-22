package database.termine

import javax.persistence.*

@Entity()
@Table(name = "TerminDetails")
class TerminDetails {

    @Id
    @Column
    var id: Long = 0

    @Column
    var treffpunkt: String? = null

    @Column
    var kommentar: String? = null

    @Column
    var kontakt: String? = null

    constructor()

    constructor(id: Long, treffpunkt: String?, kommentar: String?, kontakt: String?) {
        this.id = id
        this.treffpunkt = treffpunkt
        this.kommentar = kommentar
        this.kontakt = kontakt
    ***REMOVED***
***REMOVED***