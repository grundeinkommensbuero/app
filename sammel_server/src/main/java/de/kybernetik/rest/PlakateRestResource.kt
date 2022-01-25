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
        }

        LOG.debug("Lade alle Plakate")
        val plakate = dao.ladeAllePlakate()
        LOG.debug("${plakate} Plakate gefunden")
        return Response
            .ok()
            .entity(plakate.map { plakat -> PlakatDto.convertFromPlakat(plakat) })
            .build()
    }

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("neu")
    open fun erstellePlakat(plakatDto: PlakatDto): Response {
        if (plakatDto.benutzer.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${plakatDto.benutzer} des Plakat stimmt nicht überein mit Benutzer*in ${context.userPrincipal.name} der Request")
            plakatDto.benutzer = context.userPrincipal.name.toLong()
        }

        val plakat: Plakat
        try {
            plakat = dao.erstellePlakat(plakatDto.convertToPlakat())
        } catch (e: FehlenderWertException) {
            LOG.error(e.message)
            return Response.status(322).entity(RestFehlermeldung(e.message)).build()
        }
        LOG.info("Neues Plakat ${plakat.id} durch Benutzer ${context.userPrincipal.name} erstellt")
        return Response.ok().entity(PlakatDto.convertFromPlakat(plakat)).build()
    }

    @DELETE
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    open fun loeschePlakat(@PathParam("id") id: Long?): Response {
        if (id == null) {
            LOG.warn("Fehlende id in Lösch-Request für Plakat durch Benutzer*in ${context.userPrincipal.name}")
            return Response.status(422)
                .entity(RestFehlermeldung("Kein Plakat an den Server gesendet"))
                .build()
        }

        val plakat = dao.ladePlakat(id)

        if (plakat == null) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name} versucht unbekanntes Plakat ${id} zu löschen")
            return Response.status(422)
                .entity(RestFehlermeldung("Keine gültiges Plakat an den Server gesendet"))
                .build()
        }

        if (plakat.user_id.toString() != context.userPrincipal.name) {
            LOG.warn("Benutzer*in ${context.userPrincipal.name} versucht fremdes Plakat ${id} zu löschen. Löschversuch verhindert.")
            return Response.status(403)
                .entity(RestFehlermeldung("Plakat wurde von einer anderen Benutzer*in eingetragen"))
                .build()
        }

        LOG.info("Lösche Plakat ${plakat.id} durch Benutzer*in ${context.userPrincipal.name}")
        dao.loeschePlakat(plakat)

        return Response.ok().build()
    }

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("abgehangen/{plakatId}")
    open fun haengePlakatAb(@PathParam("plakatId") plakatId: Long): Response {
        if (System.getProperty("de.kybernetik.plakate.abhaengen")?.toBoolean() == false) {
            LOG.info("Versuch von Benutzer*in ${context.userPrincipal.name} Plakat ${plakatId} abzuhängen abgelehnt")
            return Response
                .status(423) // Locked
                .entity(RestFehlermeldung("Das Abhängen von Plakaten ist noch nicht aktiviert."))
                .build()
        }

        val plakat: Plakat?
        plakat = dao.ladePlakat(plakatId)
        if (plakat == null) return Response.status(322).entity(RestFehlermeldung("Unbekanntes Plakat")).build()
        plakat.abgehangen = true
        LOG.info("Plakat ${plakat.id} durch Benutzer ${context.userPrincipal.name} abgehängt")
        return Response.ok().entity(PlakatDto.convertFromPlakat(plakat)).build()
    }
}

data class PlakatDto(
    var id: Long? = null,
    var latitude: Double? = null,
    var longitude: Double? = null,
    var adresse: String? = null,
    var benutzer: Long? = null,
    var abgehangen: Boolean? = null
) {

    fun convertToPlakat(): Plakat {
        if (this.latitude == null)
            throw FehlenderWertException("latitude")
        if (this.longitude == null)
            throw FehlenderWertException("longitude")
        if (this.benutzer == null)
            throw FehlenderWertException("benutzer")

        return Plakat(id ?: 0, latitude!!, longitude!!, adresse ?: "", benutzer!!, abgehangen ?: false)
    }

    companion object {
        fun convertFromPlakat(plakat: Plakat): PlakatDto {
            return PlakatDto(
                plakat.id,
                plakat.latitude,
                plakat.longitude,
                plakat.adresse,
                plakat.user_id,
                plakat.abgehangen
            )
        }
    }
}