package rest

import database.DatabaseException
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
    open fun legeNeuenTerminAn(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action != null) {
            val updatedAction = dao.erstelleNeuenTermin(actionAndToken.action!!.convertToTermin())
            val token = actionAndToken.token
            if (!token.isNullOrEmpty()) dao.storeToken(updatedAction.id, token)
            return Response
                    .ok()
                    .entity(convertFromTerminWithoutDetails(updatedAction))
                    .build()
        ***REMOVED*** else return Response.status(422).build()
    ***REMOVED***

    @POST
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Path("termin")
    open fun aktualisiereTermin(termin: TerminDto): Response {
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

    @DELETE
    @Consumes(APPLICATION_JSON)
    @Path("termin")
    open fun deleteAction(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action == null || actionAndToken.action!!.id == null)
            return Response.status(422)
                    .entity(RestFehlermeldung("Beim Löschen wurde keine gültige Aktion an den Server gesendet"))
                    .build()
        if(!compareToken(actionAndToken.action!!.id!!, actionAndToken.token))
            return Response.status(403)
                    .entity(RestFehlermeldung("Token passt nicht zu Aktion"))
                    .build()
        try {
            dao.deleteAction(actionAndToken.action!!.convertToTermin())
        ***REMOVED*** catch (e: DatabaseException) {
            return Response.status(404).entity(e.message).build()
        ***REMOVED***
        return Response.ok().build()
    ***REMOVED***

    private fun compareToken(actionId: Long, tokenFromRequest: String?): Boolean {
        val tokenFromDb = dao.loadToken(actionId)?.token
        return tokenFromDb == null || tokenFromDb.equals(tokenFromRequest)
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

    data class ActionWithTokenDto(
            var action: TerminDto? = null,
            var token: String? = null)

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

