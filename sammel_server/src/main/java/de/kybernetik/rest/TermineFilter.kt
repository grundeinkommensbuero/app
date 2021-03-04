package de.kybernetik.rest

import java.time.LocalDate
import java.time.LocalTime

data class TermineFilter(
        var typen: List<String>? = emptyList(),
        var tage: List<LocalDate>? = emptyList(),
        var von: LocalTime? = null,
        var bis: LocalTime? = null,
        var orte: List<String>? = emptyList(),
        var nurEigene: Boolean = false,
        var immerEigene: Boolean = true
)