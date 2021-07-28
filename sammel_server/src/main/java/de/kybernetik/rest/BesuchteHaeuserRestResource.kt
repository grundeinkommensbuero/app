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
        LOG.debug("${besuchteHaeuser} Besuchte Häuser gefunden")
        return Response
            .ok()
            .entity(besuchteHaeuser.map { besuchtesHaus -> BesuchtesHausDto.convertFromBesuchtesHaus(besuchtesHaus) })
            .build()
    }

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("neu")
    open fun erstelleBesuchtesHaus(besuchtesHausDto: BesuchtesHausDto): Response {
        if (besuchtesHausDto.benutzer.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${besuchtesHausDto.benutzer} des Besuchten Hauses stimmt nicht überein mit Benutzer*in ${context.userPrincipal.name} der Request")
            besuchtesHausDto.benutzer = context.userPrincipal.name.toLong()
        }

        val besuchtesHaus: BesuchtesHaus
        try {
            besuchtesHaus = dao.erstelleBesuchtesHaus(besuchtesHausDto.convertToBesuchtesHaus())
        } catch (e: FehlenderWertException) {
            LOG.error(e.message)
            return Response.status(322).entity(RestFehlermeldung(e.message)).build()
        }
        LOG.info("Neues Besuchtes Haus ${besuchtesHaus.id} durch Benutzer ${context.userPrincipal.name} erstellt")
        return Response.ok().build()
    }

    @DELETE
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    open fun loescheBesuchtesHaus(@PathParam("id") id: Long?): Response {
        if (id == null) {
            LOG.warn("Fehlende id in Lösch-Request für Besuchtes Haus durch Benutzer*in ${context.userPrincipal.name}")
            return Response.status(422)
                .entity(RestFehlermeldung("Kein Besuchtes Haus an den Server gesendet"))
                .build()
        }

        val besuchtesHaus = dao.ladeBesuchtesHaus(id)

        if (besuchtesHaus == null) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name} versucht unbekanntes Besuchtes Haus ${id} zu löschen")
            return Response.status(422)
                .entity(RestFehlermeldung("Keine gültiges Besuchtes Haus an den Server gesendet"))
                .build()
        }

        if (besuchtesHaus.user_id.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name} versucht fremdes Besuchtes Haus ${id} zu löschen. Löschversuch verhindert.")
            return Response.status(403)
                .entity(RestFehlermeldung("Haus wurde von einer anderen Benutzer*in eingetragen"))
                .build()
        }

        LOG.info("Lösche Besuchtes Haus ${besuchtesHaus.id} durch Benutzer*in ${context.userPrincipal.name}")
        dao.loescheBesuchtesHaus(besuchtesHaus)

        return Response.ok().build()
    }
}

data class BesuchtesHausDto(
    var id: Long? = null,
    var latitude: Double? = null,
    var longitude: Double? = null,
    var adresse: String? = null,
    var hausteil: String? = null,
    var shape: String? = null,
    var osmId: String? = null,
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
    }

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
        }
    }
}