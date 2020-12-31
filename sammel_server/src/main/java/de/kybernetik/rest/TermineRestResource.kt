package de.kybernetik.rest

import de.kybernetik.database.DatabaseException
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TerminDetails
import de.kybernetik.database.termine.TermineDao
import de.kybernetik.database.termine.Token
import org.jboss.logging.Logger
import de.kybernetik.rest.TermineRestResource.TerminDto.Companion.convertFromTerminWithoutDetails
import de.kybernetik.services.NeueAktionenNotification
import de.kybernetik.services.PushService
import java.time.LocalDateTime
import java.time.ZonedDateTime.now
import java.time.format.DateTimeFormatter.*
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

    @EJB
    private lateinit var pushService: PushService

    @EJB
    private lateinit var neueAktionenNotification: NeueAktionenNotification

    @Context
    private lateinit var context: SecurityContext

    @POST
    @RolesAllowed("user")
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
    ***REMOVED***

    @POST
    @Path("neu")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun legeNeuenTerminAn(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action == null)
            return Response
                .status(422)
                .entity(RestFehlermeldung("Keine Aktion angegeben"))
                .build()
        val updatedAction = dao.erstelleNeuenTermin(actionAndToken.action!!.convertToTermin())
        val token = actionAndToken.token
        if (!token.isNullOrEmpty()) dao.storeToken(updatedAction.id, token)

        pushService.pusheNeueAktionenNotification(
            listOf(actionAndToken.action!!),
            "${actionAndToken.action!!.ort***REMOVED***-sofort"
        )
        neueAktionenNotification.merkeNeueAktion(actionAndToken.action!!)

        return Response
            .ok()
            .entity(convertFromTerminWithoutDetails(updatedAction))
            .build()
    ***REMOVED***

    @POST
    @Path("termin")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun aktualisiereTermin(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action?.id == null) return noValidActionResponse

        val tokenFromDb = dao.loadToken(actionAndToken.action!!.id!!)?.token
        if (tokenFromDb != null && tokenFromDb != actionAndToken.token) return Response.status(403)
            .entity(RestFehlermeldung("Bearbeiten dieser Aktion ist unautorisiert"))
            .build()

        try {
            val neuerTermin = actionAndToken.action!!.convertToTermin()
            neuerTermin.teilnehmer = dao.getTermin(actionAndToken.action!!.id!!)!!.teilnehmer
            dao.aktualisiereTermin(neuerTermin)
            informiereUeberAenderung(neuerTermin)
        ***REMOVED*** catch (e: EJBException) {
            LOG.error("Fehler beim Mergen des Termins: Termin: ${actionAndToken.action***REMOVED***\n", e)
            return Response.status(422).entity(e.message).build()
        ***REMOVED***
        return Response
            .ok()
            .build()
    ***REMOVED***

    @DELETE
    @Path("termin")
    @RolesAllowed("named")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun loescheAktion(actionAndToken: ActionWithTokenDto): Response {
        if (actionAndToken.action?.id == null)
            return noValidActionResponse

        val tokenFromDb = dao.loadToken(actionAndToken.action!!.id!!)?.token
        if (tokenFromDb != null && tokenFromDb != actionAndToken.token)
            return Response.status(403)
                .entity(RestFehlermeldung("Löschen dieser Aktion ist unautorisiert"))
                .build()

        try {
            val termin = actionAndToken.action!!.convertToTermin()
            val teilnehmer = dao.getTermin(actionAndToken.action!!.id!!)!!.teilnehmer
            dao.loescheAktion(termin)
            if (tokenFromDb != null) dao.deleteToken(Token(actionAndToken.action!!.id!!, actionAndToken.token!!))
            termin.teilnehmer = teilnehmer
            informiereUeberLoeschung(termin)
        ***REMOVED*** catch (e: DatabaseException) {
            return Response.status(404).entity(e.message).build()
        ***REMOVED***
        return Response.ok().build()
    ***REMOVED***

    @POST
    @Path("teilnahme")
    @RolesAllowed("user")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun meldeTeilnahmeAn(@QueryParam("id") id: Long?): Response {
        LOG.debug("Empfange Teilnahme an Aktion $id")

        val ungueltigeAktion = "Die angegebene Aktion ist ungültig"
        if (id == null) {
            LOG.debug("$ungueltigeAktion: Fehlende Id")
            return Response.status(422)
                .entity(RestFehlermeldung(ungueltigeAktion))
                .build()
        ***REMOVED***

        val aktion = dao.getTermin(id)
        if (aktion == null) {
            LOG.debug("$ungueltigeAktion: Unbekannte Id")
            return Response.status(422)
                .entity(RestFehlermeldung(ungueltigeAktion))
                .build()
        ***REMOVED***

        val userAusDb = benutzerDao.getBenutzer(context.userPrincipal.name.toLong())

        if (aktion.teilnehmer.map { it.id ***REMOVED***.contains(userAusDb!!.id)) {
            LOG.debug("Benutzer $id ist bereits Teilnehmer der Aktion")
            return Response.accepted().build()
        ***REMOVED***

        aktion.teilnehmer = aktion.teilnehmer.plus(userAusDb)
        dao.aktualisiereTermin(aktion)
        informiereUeberTeilnahme(userAusDb, aktion)

        return Response.accepted().build()
    ***REMOVED***

    @POST
    @Path("absage")
    @RolesAllowed("user")
    @Produces(APPLICATION_JSON)
    open fun sageTeilnahmeAb(@QueryParam("id") id: Long?): Response {
        if (id == null)
            return Response.status(422)
                .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                .build()

        val AktionAusDb = dao.getTermin(id)
        if (AktionAusDb == null)
            return Response.status(422)
                .entity(RestFehlermeldung("Die angegebene Aktion ist ungültig"))
                .build()

        val userAusDb = benutzerDao.getBenutzer(context.userPrincipal.name.toLong())
        val userAusListe = AktionAusDb.teilnehmer.find { it.id == userAusDb!!.id ***REMOVED***

        if (userAusListe == null)
            return Response.accepted().build()

        AktionAusDb.teilnehmer -= userAusListe
        dao.aktualisiereTermin(AktionAusDb)
        informiereUeberAbsage(userAusDb!!, AktionAusDb)

        return Response.accepted().build()
    ***REMOVED***

    data class TerminDto(
        var id: Long? = null,
        var beginn: LocalDateTime? = null,
        var ende: LocalDateTime? = null,
        var ort: String? = null,
        var typ: String? = null,
        var latitude: Double? = null,
        var longitude: Double? = null,
        var participants: List<BenutzerDto>? = emptyList(),
        var details: TerminDetailsDto? = TerminDetailsDto()
    ) {

        fun convertToTermin(): Termin {
            return Termin(
                id = id ?: 0,
                beginn = beginn,
                ende = ende,
                ort = ort,
                typ = typ,
                latitude = latitude,
                longitude = longitude,
                teilnehmer = if (participants == null) emptyList() else participants!!.map { it.convertToBenutzer() ***REMOVED***,
                details = details?.convertToTerminDetails(id)
            )
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
                termin.latitude,
                termin.longitude,
                termin.teilnehmer.map { BenutzerDto.convertFromBenutzer(it) ***REMOVED***)
        ***REMOVED***
    ***REMOVED***

    data class ActionWithTokenDto(
        var action: TerminDto? = null,
        var token: String? = null
    )

    data class TerminDetailsDto(
        var treffpunkt: String? = null,
        var beschreibung: String? = null,
        var kontakt: String? = null
    ) {

        fun convertToTerminDetails(id: Long?): TerminDetails {
            return TerminDetails(
                termin_id = id,
                treffpunkt = this.treffpunkt,
                beschreibung = this.beschreibung,
                kontakt = this.kontakt
            )
        ***REMOVED***

        companion object {
            fun convertFromTerminDetails(details: TerminDetails?): TerminDetailsDto? {
                if (details == null) return null
                return TerminDetailsDto(
                    treffpunkt = details.treffpunkt,
                    beschreibung = details.beschreibung,
                    kontakt = details.kontakt
                )
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***

    open fun informiereUeberTeilnahme(benutzer: Benutzer, aktion: Termin) {
        val name = if (benutzer.name.isNullOrBlank()) "Jemand" else benutzer.name!!
        var pushMessage = PushMessageDto(
            PushNotificationDto(
                "Verstärkung für deine Aktion",
                "$name ist deiner Aktion vom ${aktion.beginn?.format(ofPattern("dd.MM."))***REMOVED*** beigetreten",
                "Teilnahmen und Absagen"
            ),
            mapOf(
                "type" to "ParticipationMessage",
                "channel" to "action:${aktion.id***REMOVED***",
                "timestamp" to now().format(ISO_OFFSET_DATE_TIME),
                "action" to aktion.id,
                "username" to name,
                "joins" to true
            )
        )
        val ersteller = aktion.teilnehmer[0]

        LOG.debug("Informiere Ersteller ${ersteller.id***REMOVED*** von Aktion ${aktion.id***REMOVED***")
        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, listOf(ersteller))

        val teilnehmer = aktion.teilnehmer.minus(ersteller)
        LOG.debug("Informiere restliche Teilnehmer ${teilnehmer.map { it.id ***REMOVED******REMOVED*** von Aktion ${aktion.id***REMOVED***")
        pushMessage = PushMessageDto(
            PushNotificationDto(
                "Verstärkung für eure Aktion",
                "$name ist der Aktion vom ${aktion.beginn?.format(ofPattern("dd.MM."))***REMOVED*** beigetreten, an der du teilnimmst",
                "Teilnahmen und Absagen"
            ),
            pushMessage.data
        )
        val restlicheTeilnehmer = aktion.teilnehmer.minus(ersteller)

        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, restlicheTeilnehmer)
    ***REMOVED***

    open fun informiereUeberAbsage(benutzer: Benutzer, aktion: Termin) {
        val name = if (benutzer.name.isNullOrBlank()) "Jemand" else benutzer.name!!
        var pushMessage = PushMessageDto(
            PushNotificationDto(
                "Absage bei deiner Aktion",
                "$name nimmt nicht mehr Teil an deiner Aktion vom ${aktion.beginn?.format(ofPattern("dd.MM."))***REMOVED***",
                "Teilnahmen und Absagen"
            ), mapOf(
                "type" to "ParticipationMessage",
                "channel" to "action:${aktion.id***REMOVED***",
                "timestamp" to now().format(ISO_OFFSET_DATE_TIME),
                "action" to aktion.id,
                "username" to name,
                "joins" to false
            )
        )
        val ersteller = aktion.teilnehmer[0]

        LOG.debug("Informiere Ersteller ${ersteller.id***REMOVED*** von Aktion ${aktion.id***REMOVED***")
        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, listOf(ersteller))

        pushMessage = PushMessageDto(
            PushNotificationDto(
                "Absage bei eurer Aktion",
                "$name hat die Aktion vom ${aktion.beginn?.format(ofPattern("dd.MM."))***REMOVED*** verlassen, an der du teilnimmst",
                "Teilnahmen und Absagen"
            ), pushMessage.data
        )
        val teilnehmer = aktion.teilnehmer.minus(ersteller)

        LOG.debug("Informiere restliche Teilnehmer ${teilnehmer.map { it.id ***REMOVED******REMOVED*** von Aktion ${aktion.id***REMOVED***")
        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, teilnehmer)
    ***REMOVED***

    open fun informiereUeberAenderung(aktion: Termin) {
        val pushMessage = PushMessageDto(
            PushNotificationDto(
                "Eine Aktion an der du teilnimmst hat sich geändert",
                "${aktion.typ***REMOVED*** am ${aktion.beginn!!.format(ofPattern("dd.MM."))***REMOVED*** in ${aktion.ort***REMOVED*** (${aktion.details!!.treffpunkt***REMOVED***)",
                "Änderungen an Aktionen",
                "action:change:${aktion.id***REMOVED***"
            ),
            mapOf(
                "type" to "ActionChanged",
                "timestamp" to now().format(ISO_OFFSET_DATE_TIME),
                "action" to aktion.id
            )
        )
        val teilnehmer = aktion.teilnehmer.subList(1, aktion.teilnehmer.size)
        if (teilnehmer.size > 0)
            LOG.debug("Informiere Teilnehmer ${teilnehmer.map { it.id ***REMOVED******REMOVED*** von Aktion ${aktion.id***REMOVED*** über Änderungen")
        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, teilnehmer)
    ***REMOVED***

    open fun informiereUeberLoeschung(aktion: Termin) {
        val pushMessage = PushMessageDto(
            PushNotificationDto(
                "Eine Aktion an der du teilnimmst wurde abgesagt",
                "${aktion.typ***REMOVED*** am ${aktion.beginn!!.format(ofPattern("dd.MM."))***REMOVED*** in ${aktion.ort***REMOVED*** (${aktion.details!!.treffpunkt***REMOVED***) wurde von der Ersteller*in gelöscht",
                "Änderungen an Aktionen",
                "action:change:${aktion.id***REMOVED***"
            ),
            mapOf(
                "type" to "ActionDeleted",
                "timestamp" to now().format(ISO_OFFSET_DATE_TIME),
                "action" to aktion.id
            )
        )
        val teilnehmer = aktion.teilnehmer.subList(1, aktion.teilnehmer.size)
        if (teilnehmer.size > 0)
            LOG.debug("Informiere Teilnehmer ${teilnehmer.map { it.id ***REMOVED******REMOVED*** von Aktion ${aktion.id***REMOVED*** über Löschung")
        pushService.sendePushNachrichtAnEmpfaenger(pushMessage, teilnehmer)
    ***REMOVED***
***REMOVED***

