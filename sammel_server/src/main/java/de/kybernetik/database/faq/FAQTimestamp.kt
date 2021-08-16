package de.kybernetik.database.faq

import java.time.LocalDateTime
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "FAQ_Timestamp")
class FAQTimestamp @Suppress("unused") constructor() {
    @Id
    @Column
    lateinit var timestamp: LocalDateTime
***REMOVED***
