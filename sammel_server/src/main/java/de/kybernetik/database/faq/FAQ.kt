package de.kybernetik.database.faq

import javax.persistence.*
import javax.persistence.FetchType.EAGER

@Entity
@Table(name = "FAQ")
class FAQ @Suppress("unused") constructor() {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0

    @Column
    lateinit var title: String

    @Column
    lateinit var teaser: String

    @Column
    var rest: String? = null

    @Column(name = "order_nr")
    var order: Double? = null

    @ElementCollection(fetch = EAGER)
    @CollectionTable(name = "FAQ_Tags", joinColumns = [JoinColumn(name = "faq")])
    @Column(name = "tag")
    lateinit var tags: List<String>
***REMOVED***