package rest

import database.Stammdaten.Ort
import database.Stammdaten.StammdatenDao
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.Response

@Path("stammdaten")
open class StammdatenRestResource {

    @EJB
    private lateinit var dao: StammdatenDao

    @GET
    @Path("orte")
    @Produces("application/json")
    open fun getOrte(): Response {
        val ergebnis: List<Ort>?
        ergebnis = dao.getOrte()
        ergebnis.map { ort -> OrtDto.convertFromOrt(ort)***REMOVED***
        return Response
                .ok()
                .entity(ergebnis)
                .build()
    ***REMOVED***

    data class OrtDto(
            var id: Int? = null,
            var bezirk: String? = null,
            var ort: String? = null) {

        fun convertToOrt(): Ort {
            val ortObj = Ort()
            ortObj.id = id ?: 0
            ortObj.bezirk = bezirk ?: ""
            ortObj.ort = ort ?: ""
            return ortObj
        ***REMOVED***

        companion object {
            fun convertFromOrt(ort: Ort): OrtDto {
                return OrtDto(ort.id, ort.bezirk, ort.ort)
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***
***REMOVED***

