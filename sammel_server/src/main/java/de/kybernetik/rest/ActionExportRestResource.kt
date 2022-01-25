package de.kybernetik.rest

import de.kybernetik.database.termine.Termin
import de.kybernetik.database.termine.TermineDao
import org.jboss.logging.Logger
import java.time.LocalDate
import java.time.format.DateTimeFormatter.ofPattern
import javax.annotation.security.PermitAll
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response

@Path("action-export")
@PermitAll
@Stateless
open class ActionExportRestResource {
    private val LOG = Logger.getLogger(TermineRestResource::class.java)

    @EJB
    private lateinit var dao: TermineDao

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    open fun getActionsAsGeoJson(): Response {
        LOG.debug("Bearbeite Anfrage nach Aktionen als GeoJson")
        val filter =
            TermineFilter(
                emptyList(),
                (0L..7L).map { days -> LocalDate.now().plusDays(days) },
                null,
                null,
                emptyList()
            )
        val actions = dao.getTermine(filter, null)
        val geoJsonActions = actions
            .filter { action -> action.longitude != null && action.latitude != null }
            .map { action -> GeoJsonAction.convertFromAction(action) }
        val geoJsoncollection = GeoJsonCollection(geoJsonActions)
        LOG.debug("${geoJsonActions.size} Aktionen ausgegeben")
        return Response.ok().entity(geoJsoncollection).header("Access-Control-Allow-Origin", "*").build()
    }

    data class GeoJsonCollection(val features: List<GeoJsonAction>) {
        @Suppress("unused")
        val type = "FeatureCollection"
    }

    data class GeoJsonAction(
        val name: String, val properties: GeoJsonProperties, val geometry: GeoJsonGeometry
    ) {
        val type = "Feature"

        data class GeoJsonProperties(val name: String, val description: String)

        data class GeoJsonGeometry(val coordinates: List<Double>) {
            val type = "Point"
        }

        companion object {
            fun convertFromAction(action: Termin): GeoJsonAction {

                if (action.latitude == null || action.longitude == null)
                    throw GeoJsonParseException("Kann kein GeoJson-Objekt ohne Koordinaten erzeugen (Aktions-ID ${action.id}")

                return GeoJsonAction(
                    action.typ ?: "Aktion",
                    GeoJsonProperties(action.typ ?: "Aktion", generateJsonDescription(action)),
                    GeoJsonGeometry(listOf(action.longitude!!, action.latitude!!))
                )
            }

            fun generateJsonDescription(action: Termin): String =
                "${action.details?.beschreibung ?: "Zu dieser Aktion gibt es keine Beschreibung"}\n" +
                        (if (action.beginn != null) "\nam ${
                            LocalDate.from(action.beginn).format(ofPattern("dd.MM.yyyy"))
                        }" +
                                " ab ${action.beginn!!.format(ofPattern("HH:mm"))} Uhr" +
                                if (action.ende != null)
                                    " bis ${action.ende!!.format(ofPattern("HH:mm"))} Uhr"
                                else ""
                        else "") +
                        if (action.details?.treffpunkt != null) "\nTreffpunkt: ${action.details!!.treffpunkt!!}"
                        else ""
        }

        class GeoJsonParseException(message: String) : Exception(message)
    }
}