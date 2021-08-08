package de.kybernetik.rest

import de.kybernetik.database.vorbehalte.Vorbehalte
import de.kybernetik.database.vorbehalte.VorbehalteDao
import de.kybernetik.shared.FehlenderWertException
import org.jboss.logging.Logger
import java.time.LocalDate
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.Consumes
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext

@Stateless
@Path("vorbehalte")
open class VorbehalteRestRessource {
    private val LOG = Logger.getLogger(VorbehalteRestRessource::class.java)

    @EJB
    private lateinit var dao: VorbehalteDao

    @Context
    private lateinit var context: SecurityContext

    @POST
    @RolesAllowed("user")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    open fun legeNeueVorbehalteAn(vorbehalte: VorbehalteDto): Response {
        LOG.info("Lege neue Vorbehalte an durch ${context.userPrincipal.name***REMOVED***")
        LOG.debug("Vorbehalte: ${vorbehalte.id***REMOVED***, ${vorbehalte.vorbehalte***REMOVED***, ${vorbehalte.benutzer***REMOVED***, ${vorbehalte.datum***REMOVED***, ${vorbehalte.ort***REMOVED***")
        println("Vorbehalte: ${vorbehalte.id***REMOVED***, ${vorbehalte.vorbehalte***REMOVED***, ${vorbehalte.benutzer***REMOVED***, ${vorbehalte.datum***REMOVED***, ${vorbehalte.ort***REMOVED***")
        if (context.userPrincipal.name != vorbehalte.benutzer.toString()) {
            LOG.warn("Benutzer*in ${vorbehalte.benutzer***REMOVED*** der Vorbehalte stimmt nicht überein mit Benutzer*in ${context.userPrincipal.name***REMOVED*** der Request")
            vorbehalte.benutzer = context.userPrincipal.name.toLong()
        ***REMOVED***
        try {
            dao.erzeugeNeueVorbehalte(vorbehalte.convertToVorbehalte())
        ***REMOVED*** catch (e: FehlenderWertException) {
            LOG.error(e.message)
            return Response.status(322).entity(RestFehlermeldung(e.message)).build()
        ***REMOVED***
        return Response.ok().build()
    ***REMOVED***
***REMOVED***

data class VorbehalteDto(
    var id: Long? = null,
    var vorbehalte: String? = null,
    var benutzer: Long? = null,
    var datum: LocalDate? = null,
    var ort: String? = null
) {
    fun convertToVorbehalte(): Vorbehalte {
        if (this.benutzer == null) throw FehlenderWertException("Benutzer")
        if (this.datum == null) throw FehlenderWertException("Datum")
        if (this.ort == null) throw FehlenderWertException("Ort")
        return Vorbehalte(id ?: 0, vorbehalte ?: "", benutzer!!, datum!!, ort!!)
    ***REMOVED***

    companion object {
        fun convertFromVorbehalte(vorbehalte: Vorbehalte): VorbehalteDto {
            return VorbehalteDto(
                vorbehalte.id,
                vorbehalte.vorbehalte,
                vorbehalte.benutzer,
                vorbehalte.datum,
                vorbehalte.ort
            )
        ***REMOVED***
    ***REMOVED***
***REMOVED***
