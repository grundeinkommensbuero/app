package database.termine

import javax.persistence.*

@Entity()
@Table(name = "Token")
class Token(
        // FIXME Sollte eigentlich auf id-Spalte von Termin verweisen und idealerweise kaskadiert gelöscht werden
        @Id
        @Column(name = "action_id")
        var actionId: Long,

        @Column var token: String) {
***REMOVED***
