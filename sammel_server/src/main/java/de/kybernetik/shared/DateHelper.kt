package de.kybernetik.shared

import java.time.LocalDate
import java.time.ZoneId
import java.util.*

fun LocalDate.toDate(): Date = Date.from(this.atStartOfDay(ZoneId.systemDefault()).toInstant())