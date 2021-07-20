package de.kybernetik.rest

import de.kybernetik.database.plakate.Plakat
import de.kybernetik.database.plakate.PlakateDao
import de.kybernetik.shared.FehlenderWertException
import org.jboss.logging.Logger
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext

@Stateless
@Path("plakate")
open class PlakateRestResource {
    private val LOG = Logger.getLogger(PlakateRestResource::class.java)

    @EJB
    private lateinit var dao: PlakateDao

    @Context
    private lateinit var context: SecurityContext

    @GET
    @RolesAllowed("app")
    @Produces(MediaType.APPLICATION_JSON)
    open fun getPlakate(): Response {
        if (System.getProperty("de.kybernetik.plakate.secret")?.toBoolean() == true) {
            LOG.debug("Lade keine Plakate, weil Plakate geheim gehalten werden")
            return Response.status(200).entity(emptyList<Plakat>()).build()
        ***REMOVED***

        LOG.debug("Lade alle Plakate")
        val plakate = dao.ladeAllePlakate()
        LOG.debug("${plakate***REMOVED*** Plakate gefunden")
        return Response
            .ok()
            .entity(plakate.map { plakat -> PlakatDto.convertFromPlakat(plakat) ***REMOVED***)
            .build()
    ***REMOVED***

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("neu")
    open fun erstellePlakat(plakatDto: PlakatDto): Response {
        if (plakatDto.benutzer.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${plakatDto.benutzer***REMOVED*** des Plakat stimmt nicht überein mit Benutzer*in ${context.userPrincipal.name***REMOVED*** der Request")
            plakatDto.benutzer = context.userPrincipal.name.toLong()
        ***REMOVED***

        val plakat: Plakat
        try {
            plakat = dao.erstellePlakat(plakatDto.convertToPlakat())
        ***REMOVED*** catch (e: FehlenderWertException) {
            LOG.error(e.message)
            return Response.status(322).entity(RestFehlermeldung(e.message)).build()
        ***REMOVED***
        LOG.info("Neues Plakat ${plakat.id***REMOVED*** durch Benutzer ${context.userPrincipal.name***REMOVED*** erstellt")
        return Response.ok().entity(plakat).build()
    ***REMOVED***

    @DELETE
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id***REMOVED***")
    open fun loeschePlakat(@PathParam("id") id: Long?): Response {
        if (id == null) {
            LOG.warn("Fehlende id in Lösch-Request für Plakat durch Benutzer*in ${context.userPrincipal.name***REMOVED***")
            return Response.status(422)
                .entity(RestFehlermeldung("Kein Plakat an den Server gesendet"))
                .build()
        ***REMOVED***

        val plakat = dao.ladePlakat(id)

        if (plakat == null) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name***REMOVED*** versucht unbekanntes Plakat ${id***REMOVED*** zu löschen")
            return Response.status(422)
                .entity(RestFehlermeldung("Keine gültiges Plakat an den Server gesendet"))
                .build()
        ***REMOVED***

        if (plakat.user_id.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name***REMOVED*** versucht fremdes Plakat ${id***REMOVED*** zu löschen. Löschversuch verhindert.")
            return Response.status(403)
                .entity(RestFehlermeldung("Plakat wurde von einer anderen Benutzer*in eingetragen"))
                .build()
        ***REMOVED***

        LOG.info("Lösche Plakat ${plakat.id***REMOVED*** durch Benutzer*in ${context.userPrincipal.name***REMOVED***")
        dao.loeschePlakat(plakat)

        return Response.ok().build()
    ***REMOVED***
***REMOVED***

data class PlakatDto(
    var id: Long? = null,
    var latitude: Double? = null,
    var longitude: Double? = null,
    var adresse: String? = null,
    var benutzer: Long? = null
) {

    fun convertToPlakat(): Plakat {
        if (this.latitude == null)
            throw FehlenderWertException("latitude")
        if (this.longitude == null)
            throw FehlenderWertException("longitude")
        if (this.benutzer == null)
            throw FehlenderWertException("benutzer")

        return Plakat(id ?: 0, latitude!!, longitude!!, adresse ?: "", benutzer!!)
    ***REMOVED***

    companion object {
        fun convertFromPlakat(plakat: Plakat): PlakatDto {
            return PlakatDto(
                plakat.id,
                plakat.latitude,
                plakat.longitude,
                plakat.adresse,
                plakat.user_id
            )
        ***REMOVED***
    ***REMOVED***
***REMOVED***