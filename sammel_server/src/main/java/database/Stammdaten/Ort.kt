package database.Stammdaten

import javax.persistence.*

@Entity()
@Table(name = "Stamm_Orte")
class Ort {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int = 0

    @Column
    var bezirk: String = ""

    @Column
    var ort: String = ""
}