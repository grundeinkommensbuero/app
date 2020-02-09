package database.termine

import javax.persistence.*

@Entity()
@Table(name = "Token")
class Token {
        // FIXME Sollte eigentlich auf id-Spalte von Termin verweisen und idealerweise kaskadiert gelöscht werden
        @Id
        @Column(name = "action_id")
        var actionId: Long = 0L

        @Column
        lateinit var token: String

        constructor()

        constructor(actionId: Long, token: String) {
                this.actionId = actionId;
                this.token = token;
        ***REMOVED***

***REMOVED***
