package rest

import database.Stammdaten.Ort
import database.termine.Termin
import database.termine.TermineDao
import org.jboss.logging.Logger
import java.time.LocalDateTime
import javax.ejb.EJB
import javax.ejb.EJBException
import javax.ws.rs.*
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response

@Path("termine")
open class TermineRestResource {
    private val LOG = Logger.getLogger(TermineRestResource::class.java)

    @EJB
    private lateinit var dao: TermineDao

    @GET
    @Produces(APPLICATION_JSON)
    open fun getTermine(): Response {
        val ergebnis: List<TerminDto>?
        ergebnis = dao.getTermine().map { termin -> TerminDto.convertFromTermin(termin) }
        return Response
                .ok()
                .entity(ergebnis)
                .build()
    }

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Path("neu")
    open fun legeNeuenTerminAn(termin: TerminDto): Response {
        val aktualisierterTermin = dao.erstelleNeuenTermin(termin.convertToTermin())
        return Response
                .ok()
                .entity(TerminDto.convertFromTermin(aktualisierterTermin))
                .build()
    }

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun aktualisiereTermin(termin: TerminDto): Response {
        try {
            dao.aktualisiereTermin(termin.convertToTermin())
        } catch (e: EJBException) {
            LOG.error("Fehler beim Mergen eines Termins. " +
                    "Möglicherweise hat ein Client versucht einen Termin mit unbekannter ID zu aktualisieren\n" +
                    "Termin: $termin\n", e)
            return Response.status(422).build()
        }
        return Response
                .ok()
                .build()
    }

    data class TerminDto(
            var id: Long? = null,
            var beginn: LocalDateTime? = null,
            var ende: LocalDateTime? = null,
            var ort: Ort? = null,
            var typ: String? = null,
            var teilnehmer: List<BenutzerDto>? = emptyList()) {

        fun convertToTermin(): Termin {
            val termin = Termin()
            termin.id = id ?: 0
            termin.beginn = beginn
            termin.ende = ende
            termin.ort = ort
            termin.typ = typ
            termin.teilnehmer =
                    if (teilnehmer == null) {
                        emptyList()
                    } else {
                        teilnehmer!!.map { teilnehmer -> teilnehmer.convertToBenutzer() }
                    }
            return termin
        }

        companion object {
            fun convertFromTermin(termin: Termin): TerminDto {
                return TerminDto(
                        termin.id,
                        termin.beginn,
                        termin.ende,
                        termin.ort,
                        termin.typ,
                        termin.teilnehmer.map { teilnehmer -> BenutzerDto.convertFromBenutzer(teilnehmer) })
            }
        }
    }
}

