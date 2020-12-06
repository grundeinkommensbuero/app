package de.kybernetik.rest

import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import java.lang.Exception
import java.time.LocalDate
import java.time.format.DateTimeFormatter.ofPattern
import javax.annotation.security.PermitAll
import javax.ejb.EJB
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response

@Path("action-export")
@PermitAll
open class ActionExportRestResource {
    private val LOG = Logger.getLogger(TermineRestResource::class.java)
    open val next7days = (0L..7L).map { days -> LocalDate.now().plusDays(days) ***REMOVED***

    @EJB
    private lateinit var dao: TermineDao

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    open fun getActionsAsGeoJson(): Response {
        LOG.debug("Bearbeite Anfrage nach Aktionen als GeoJson")
        val filter = TermineFilter(emptyList(), next7days, null, null, emptyList())
        val actions = dao.getTermine(filter)
        LOG.info("Aktionen ${actions.map { action -> action.id ***REMOVED******REMOVED*** gefunden")
        val geoJsonActions = actions
                .filter { action -> action.longitude != null && action.lattitude != null ***REMOVED***
                .map { action -> GeoJsonAction.convertFromAction(action) ***REMOVED***
        val geoJsoncollection = GeoJsonCollection(geoJsonActions)
        LOG.debug("${geoJsonActions.size***REMOVED*** Aktionen ausgegeben")
        return Response.ok().entity(geoJsoncollection).build()
    ***REMOVED***

    data class GeoJsonCollection(val features: List<GeoJsonAction>) {
        @Suppress("unused")
        val type = "FeatureCollection"
    ***REMOVED***

    data class GeoJsonAction(val name: String, val properties: GeoJsonProperties, val geometry: GeoJsonGeometry
    ) {
        val type = "Feature"

        data class GeoJsonProperties(val name: String, val description: String)

        data class GeoJsonGeometry(val coordinates: List<Double>) {
            val type = "Point"
        ***REMOVED***

        companion object {
            fun convertFromAction(action: Termin): GeoJsonAction {

                if (action.lattitude == null || action.longitude == null)
                    throw GeoJsonParseException("Kann kein GeoJson-Objekt ohne Koordinaten erzeugen (Aktions-ID ${action.id***REMOVED***")

                return GeoJsonAction(
                        action.typ ?: "Aktion",
                        GeoJsonProperties(action.typ ?: "Aktion", generateJsonDescription(action)),
                        GeoJsonGeometry(listOf(action.longitude!!, action.lattitude!!)))
            ***REMOVED***

            fun generateJsonDescription(action: Termin): String =
                    "${action.details?.beschreibung ?: "Zu dieser Aktion gibt es keine Beschreibung"***REMOVED***\n" +
                            (if (action.beginn != null) "\nam ${LocalDate.from(action.beginn).format(ofPattern("dd.MM.yyyy"))***REMOVED***" +
                                    "\nab ${action.beginn!!.format(ofPattern("HH:mm"))***REMOVED*** Uhr" +
                                    if (action.ende != null)
                                        " bis ${action.ende!!.format(ofPattern("HH:mm"))***REMOVED*** Uhr"
                                    else ""
                            else "") +
                            if (action.details?.treffpunkt != null) "\nTreffpunkt: ${action.details!!.treffpunkt!!***REMOVED***"
                            else ""
        ***REMOVED***

        class GeoJsonParseException(message: String) : Exception(message)
    ***REMOVED***
***REMOVED***