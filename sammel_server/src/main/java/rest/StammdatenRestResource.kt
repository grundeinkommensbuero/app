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
            var ort: String? = null,
            var lattitude: Double? = null,
            var longitude: Double? = null) {

        fun convertToOrt(): Ort {
            return Ort(id ?: 0, bezirk ?: "", ort ?: "", lattitude, longitude)
        ***REMOVED***

        companion object {
            fun convertFromOrt(ort: Ort): OrtDto {
                return OrtDto(ort.id, ort.bezirk, ort.ort, ort.lattitude, ort.longitude)
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***
***REMOVED***

