package de.kybernetik.rest

import de.kybernetik.database.besuchteshaus.BesuchtesHaus
import de.kybernetik.database.besuchteshaus.BesuchtesHausDao
import de.kybernetik.shared.FehlenderWertException
import org.jboss.logging.Logger
import java.time.LocalDate
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext

@Stateless
@Path("besuchteHaeuser")
open class BesuchteHaeuserRestResource {
    private val LOG = Logger.getLogger(BesuchteHaeuserRestResource::class.java)

    @EJB
    private lateinit var dao: BesuchtesHausDao

    @Context
    private lateinit var context: SecurityContext

    @GET
    @RolesAllowed("app")
    @Produces(MediaType.APPLICATION_JSON)
    open fun getBesuchteHaeuser(): Response {
        LOG.debug("Lade alle Besuchten Häuser")
        val besuchteHaeuser = dao.ladeAlleBesuchtenHaeuser()
        LOG.debug("${besuchteHaeuser***REMOVED*** Besuchte Häuser gefunden")
        return Response
            .ok()
            .entity(besuchteHaeuser.map { besuchtesHaus -> BesuchtesHausDto.convertFromBesuchtesHaus(besuchtesHaus) ***REMOVED***)
            .build()
    ***REMOVED***

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("neu")
    open fun erstelleBesuchtesHaus(besuchtesHausDto: BesuchtesHausDto): Response {
        if (besuchtesHausDto.benutzer.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${besuchtesHausDto.benutzer***REMOVED*** des Besuchten Hauses stimmt nicht überein mit Benutzer*in ${context.userPrincipal.name***REMOVED*** der Request")
            besuchtesHausDto.benutzer = context.userPrincipal.name.toLong()
        ***REMOVED***

        val besuchtesHaus: BesuchtesHaus
        try {
            besuchtesHaus = dao.erstelleBesuchtesHaus(besuchtesHausDto.convertToBesuchtesHaus())
        ***REMOVED*** catch (e: FehlenderWertException) {
            LOG.error(e.message)
            return Response.status(322).entity(RestFehlermeldung(e.message)).build()
        ***REMOVED***
        LOG.info("Neues Besuchtes Haus ${besuchtesHaus.id***REMOVED*** durch Benutzer ${context.userPrincipal.name***REMOVED*** erstellt")
        return Response.ok().entity(BesuchtesHausDto.convertFromBesuchtesHaus(besuchtesHaus)).build()
    ***REMOVED***

    @DELETE
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id***REMOVED***")
    open fun loescheBesuchtesHaus(@PathParam("id") id: Long?): Response {
        if (id == null) {
            LOG.warn("Fehlende id in Lösch-Request für Besuchtes Haus durch Benutzer*in ${context.userPrincipal.name***REMOVED***")
            return Response.status(422)
                .entity(RestFehlermeldung("Kein Besuchtes Haus an den Server gesendet"))
                .build()
        ***REMOVED***

        val besuchtesHaus = dao.ladeBesuchtesHaus(id)

        if (besuchtesHaus == null) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name***REMOVED*** versucht unbekanntes Besuchtes Haus ${id***REMOVED*** zu löschen")
            return Response.status(422)
                .entity(RestFehlermeldung("Keine gültiges Besuchtes Haus an den Server gesendet"))
                .build()
        ***REMOVED***

        if (besuchtesHaus.user_id.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name***REMOVED*** versucht fremdes Besuchtes Haus ${id***REMOVED*** zu löschen. Löschversuch verhindert.")
            return Response.status(403)
                .entity(RestFehlermeldung("Haus wurde von einer anderen Benutzer*in eingetragen"))
                .build()
        ***REMOVED***

        LOG.info("Lösche Besuchtes Haus ${besuchtesHaus.id***REMOVED*** durch Benutzer*in ${context.userPrincipal.name***REMOVED***")
        dao.loescheBesuchtesHaus(besuchtesHaus)

        return Response.ok().build()
    ***REMOVED***
***REMOVED***

data class BesuchtesHausDto(
    var id: Long? = null,
    var latitude: Double? = null,
    var longitude: Double? = null,
    var adresse: String? = null,
    var hausteil: String? = null,
    var shape: String? = null,
    var osmId: Long? = null,
    var datum: LocalDate? = null,
    var benutzer: Long? = null
) {

    fun convertToBesuchtesHaus(): BesuchtesHaus {
        if (this.latitude == null)
            throw FehlenderWertException("latitude")
        if (this.longitude == null)
            throw FehlenderWertException("longitude")
        if (this.benutzer == null)
            throw FehlenderWertException("benutzer")

        return BesuchtesHaus(
            id ?: 0, latitude!!, longitude!!, adresse ?: "", hausteil, shape, osmId, datum ?: LocalDate.now(),
            benutzer!!
        )
    ***REMOVED***

    companion object {
        fun convertFromBesuchtesHaus(besuchtesHaus: BesuchtesHaus): BesuchtesHausDto {
            return BesuchtesHausDto(
                besuchtesHaus.id,
                besuchtesHaus.latitude,
                besuchtesHaus.longitude,
                besuchtesHaus.adresse,
                besuchtesHaus.hausteil,
                besuchtesHaus.polygon,
                besuchtesHaus.osm_id,
                besuchtesHaus.datum,
                besuchtesHaus.user_id
            )
        ***REMOVED***
    ***REMOVED***
***REMOVED***