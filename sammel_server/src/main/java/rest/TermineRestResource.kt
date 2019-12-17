package rest

import database.stammdaten.Ort
import database.termine.Termin
import database.termine.TerminDetails
import database.termine.TermineDao
import org.jboss.logging.Logger
import rest.TermineRestResource.TerminDto.Companion.convertFromTerminWithoutDetails
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

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun getTermine(filter: TermineFilter?): Response {
        val termine = dao.getTermine(filter ?: TermineFilter())
        return Response
                .ok()
                .entity(termine.map { termin -> convertFromTerminWithoutDetails(termin) ***REMOVED***)
                .build()
    ***REMOVED***

    @GET
    @Path("termin")
    @Produces(APPLICATION_JSON)
    open fun getTermin(@QueryParam("id") id: Long): Response {
        val termin = dao.getTermin(id)
        termin.details
        return Response
                .ok()
                .entity(TerminDto.convertFromTerminWithDetails(termin))
                .build()
    ***REMOVED***

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Path("neu")
    open fun legeNeuenTerminAn(termin: TerminDto): Response {
        val aktualisierterTermin = dao.erstelleNeuenTermin(termin.convertToTermin())
        return Response
                .ok()
                .entity(convertFromTerminWithoutDetails(aktualisierterTermin))
                .build()
    ***REMOVED***

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Path("termin")
    open fun aktualisiereTermin(termin: TerminDto): Response {
        LOG.info("aktualisiereTermin() mit Termin-Typ ${termin.typ***REMOVED***")
        LOG.info("aktualisiereTermin() mit Termin-Details ${termin.details?.kommentar***REMOVED***: ${termin.details?.treffpunkt***REMOVED***, ${termin.details?.kommentar***REMOVED***, ${termin.details?.kontakt***REMOVED***")
        try {
            dao.aktualisiereTermin(termin.convertToTermin())
        ***REMOVED*** catch (e: EJBException) {
            LOG.error("Fehler beim Mergen eines Termins. " +
                    "Möglicherweise hat ein Client versucht einen Termin mit unbekannter ID zu aktualisieren\n" +
                    "Termin: $termin\n", e)
            return Response.status(422).build()
        ***REMOVED***
        return Response
                .ok()
                .build()
    ***REMOVED***

    data class TerminDto(
            var id: Long? = null,
            var beginn: LocalDateTime? = null,
            var ende: LocalDateTime? = null,
            var ort: Ort? = null,
            var typ: String? = null,
            var details: TerminDetailsDto? = TerminDetailsDto()) {

        fun convertToTermin(): Termin {
            return Termin(
                    id = id ?: 0,
                    beginn = beginn,
                    ende = ende,
                    ort = ort,
                    typ = typ,
                    teilnehmer = emptyList(),
                    details = details?.convertToTerminDetails())
        ***REMOVED***

        companion object {
            fun convertFromTerminWithDetails(termin: Termin): TerminDto {
                val terminDto = convertFromTerminWithoutDetails(termin)
                terminDto.details = TerminDetailsDto.convertFromTerminDetails(termin.details)
                return terminDto
            ***REMOVED***

            fun convertFromTerminWithoutDetails(termin: Termin): TerminDto = TerminDto(
                    termin.id,
                    termin.beginn,
                    termin.ende,
                    termin.ort,
                    termin.typ,
                    null)
        ***REMOVED***
    ***REMOVED***

    data class TerminDetailsDto(
            var id: Long? = null,
            var treffpunkt: String? = null,
            var kommentar: String? = null,
            var kontakt: String? = null) {

        fun convertToTerminDetails(): TerminDetails {
            return TerminDetails(
                    id = this.id ?: 0,
                    treffpunkt = this.treffpunkt,
                    kommentar = this.kommentar,
                    kontakt = this.kontakt)
        ***REMOVED***

        companion object {
            fun convertFromTerminDetails(details: TerminDetails?): TerminDetailsDto? {
                if (details == null) return null
                return TerminDetailsDto(
                        id = details.id,
                        treffpunkt = details.treffpunkt,
                        kommentar = details.kommentar,
                        kontakt = details.kontakt)
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***
***REMOVED***

