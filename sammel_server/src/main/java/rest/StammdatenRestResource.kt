package rest

import database.stammdaten.Ort
import database.stammdaten.StammdatenDao
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
        val dtoListe = ergebnis.map { ort -> OrtDto.convertFromOrt(ort)***REMOVED***.toList()
        return Response
                .ok()
                .entity(dtoListe)
                .build()
    ***REMOVED***

    data class OrtDto(
            var id: Int? = null,
            var bezirk: String? = null,
            var ort: String? = null) {

        fun convertToOrt(): Ort {
            return Ort(id ?: 0, bezirk ?: "", ort ?: "", 52.518611, 13.408333)
        ***REMOVED***

        companion object {
            fun convertFromOrt(ort: Ort): OrtDto {
                return OrtDto(ort.id, ort.bezirk, ort.ort)
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***
***REMOVED***

