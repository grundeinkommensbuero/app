package rest

import database.DatabaseException
import database.benutzer.BenutzerDao
import database.stammdaten.Ort
import database.termine.Termin
import database.termine.TerminDetails
import database.termine.TermineDao
import database.termine.Token
import org.jboss.logging.Logger
import rest.TermineRestResource.TerminDto.Companion.convertFromTerminWithoutDetails
import java.time.LocalDateTime
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.EJBException
import javax.ejb.Stateless
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext


@Stateless
@Path("termine")
open class TermineRestResource {
    private val LOG = Logger.getLogger(TermineRestResource::class.java)

    private val noValidActionResponse = Response.status(422)
            .entity(RestFehlermeldung("Keine gültige Aktion an den Server gesendet"))
            .build()

    @EJB
    private lateinit var dao: TermineDao

    @EJB
    private lateinit var benutzerDao: BenutzerDao

    @Context
    lateinit var context: SecurityContext

    @POST
    @RolesAllowed("user")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun getTermine(filter: TermineFilter?): Response {
        val termine = dao.getTermine(filter ?: TermineFilter())
        return Response
                .ok()
                .entity(termine.map { termin -> convertFromTerminWithoutDetails(termin) })
                .build()
    }

    @GET
    @Path("termin")
    @RolesAllowed("user")
    @Produces(APPLICATION_JSON)
    open fun getTermin(@QueryParam("id") id: Long?): Response {
        if (id == null)
            return Response
                    .status(422)
                    .entity("Keine Aktions-ID angegeben")
                    .build()
        val termin = dao.getTermin(id)
        if (termin == null)
            return Response
                    .status(433)
                    .entity("Unbekannte Aktion abgefragt")
                    .build()
        termin.details
        return Response
                .ok()
                .entity(TerminDto.convertFromTerminWithDetails(termin))
                .build()
    }

    @POST
    @Path("neu")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun legeNeuenTerminAn(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action != null) {
            val updatedAction = dao.erstelleNeuenTermin(actionAndToken.action!!.convertToTermin())
            val token = actionAndToken.token
            if (!token.isNullOrEmpty()) dao.storeToken(updatedAction.id, token)
            return Response
                    .ok()
                    .entity(convertFromTerminWithoutDetails(updatedAction))
                    .build()
        } else return Response.status(422).build()
    }

    @POST
    @Path("termin")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun aktualisiereTermin(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action == null || actionAndToken.action!!.id == null) return noValidActionResponse

        val tokenFromDb = dao.loadToken(actionAndToken.action!!.id!!)?.token
        if (tokenFromDb != null && tokenFromDb != actionAndToken.token) return Response.status(403)
                .entity(RestFehlermeldung("Bearbeiten dieser Aktion ist unautorisiert"))
                .build()

        try {
            dao.aktualisiereTermin(actionAndToken.action!!.convertToTermin())
        } catch (e: EJBException) {
            LOG.error("Fehler beim Mergen eines Termins. " +
                    "Möglicherweise hat ein Client versucht einen Termin mit unbekannter ID zu aktualisieren\n" +
                    "Termin: ${actionAndToken.action}\n", e)
            return Response.status(422).build()
        }
        return Response
                .ok()
                .build()
    }

    @DELETE
    @Path("termin")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun deleteAction(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action?.id == null)
            return noValidActionResponse

        val tokenFromDb = dao.loadToken(actionAndToken.action!!.id!!)?.token
        if (tokenFromDb != null && tokenFromDb != actionAndToken.token)
            return Response.status(403)
                    .entity(RestFehlermeldung("Löschen dieser Aktion ist unautorisiert"))
                    .build()

        try {
            dao.deleteAction(actionAndToken.action!!.convertToTermin())
            if (tokenFromDb != null) dao.deleteToken(Token(actionAndToken.action!!.id!!, actionAndToken.token!!))
        } catch (e: DatabaseException) {
            return Response.status(404).entity(e.message).build()
        }
        return Response.ok().build()
    }

    @POST
    @Path("teilnahme")
    @RolesAllowed("user")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun meldeTeilnahmeAn(@QueryParam("id") id: Long?): Response {
        if (id == null)
            return Response.status(422)
                    .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                    .build()

        val terminAusDb = dao.getTermin(id)
        if (terminAusDb == null)
            return Response.status(422)
                    .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                    .build()

        val userAusDb = benutzerDao.getBenutzer(context.userPrincipal.name.toLong())
        if (userAusDb == null)
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Dein Benutzer konnte nicht gefunden werden"))
                    .build()

        if (terminAusDb.teilnehmer.map { it.id }.contains(userAusDb.id))
            return Response.accepted().build()

        terminAusDb.teilnehmer = terminAusDb.teilnehmer.plus(userAusDb)
        dao.aktualisiereTermin(terminAusDb)

        return Response.accepted().build()
    }

    @POST
    @Path("absage")
    @RolesAllowed("user")
    @Produces(APPLICATION_JSON)
    open fun sageTeilnahmeAb(@QueryParam("id") id: Long?): Response {
        if (id == null)
            return Response.status(422)
                    .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                    .build()

        val terminAusDb = dao.getTermin(id)
        if (terminAusDb == null)
            return Response.status(422)
                    .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                    .build()

        val userAusDb = benutzerDao.getBenutzer(context.userPrincipal.name.toLong())
        if (userAusDb == null)
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Dein Benutzer konnte nicht gefunden werden"))
                    .build()

        val userAusListe = terminAusDb.teilnehmer.find { it.id == userAusDb.id }

        if (userAusListe == null)
            return Response.accepted().build()

        terminAusDb.teilnehmer -= userAusListe
        dao.aktualisiereTermin(terminAusDb)

        return Response.accepted().build()
    }

    data class TerminDto(
            var id: Long? = null,
            var beginn: LocalDateTime? = null,
            var ende: LocalDateTime? = null,
            var ort: Ort? = null,
            var typ: String? = null,
            var lattitude: Double? = null,
            var longitude: Double? = null,
            var participants: List<BenutzerDto>? = emptyList(),
            var details: TerminDetailsDto? = TerminDetailsDto()) {

        fun convertToTermin(): Termin {
            return Termin(
                    id = id ?: 0,
                    beginn = beginn,
                    ende = ende,
                    ort = ort,
                    typ = typ,
                    lattitude = lattitude,
                    longitude = longitude,
                    teilnehmer = if (participants == null) emptyList() else participants!!.map { it.convertToBenutzer() },
                    details = details?.convertToTerminDetails())
        }

        companion object {
            fun convertFromTerminWithDetails(termin: Termin): TerminDto {
                val terminDto = convertFromTerminWithoutDetails(termin)
                terminDto.details = TerminDetailsDto.convertFromTerminDetails(termin.details)
                return terminDto
            }

            fun convertFromTerminWithoutDetails(termin: Termin): TerminDto = TerminDto(
                    termin.id,
                    termin.beginn,
                    termin.ende,
                    termin.ort,
                    termin.typ,
                    termin.lattitude,
                    termin.longitude,
                    termin.teilnehmer.map { BenutzerDto.convertFromBenutzer(it) })
        }
    }

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
        }

        companion object {
            fun convertFromTerminDetails(details: TerminDetails?): TerminDetailsDto? {
                if (details == null) return null
                return TerminDetailsDto(
                        id = details.id,
                        treffpunkt = details.treffpunkt,
                        kommentar = details.kommentar,
                        kontakt = details.kontakt)
            }
        }
    }
}

