package rest

import java.time.LocalDate
import java.time.LocalTime

class TermineFilter(
        val typen: List<String> = emptyList(),
        val tage: List<LocalDate> = emptyList(),
        val von: LocalTime? = null,
        val bis: LocalTime? = null,
        val orte: List<StammdatenRestResource.OrtDto> = emptyList()
)