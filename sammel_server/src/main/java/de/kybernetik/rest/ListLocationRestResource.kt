package de.kybernetik.rest

import de.kybernetik.database.listlocations.ListLocation
import de.kybernetik.database.listlocations.ListLocationDao
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Response

@Path("listlocations")
@Stateless
open class ListLocationRestResource {

    @EJB
    private lateinit var dao: ListLocationDao

    @GET
    @Path("actives")
    @RolesAllowed("app")
    @Produces("application/json")
    open fun getActiveListLocations(): Response {
        val listLocations: List<ListLocation>? = dao.getActiveListLocations()
        val listLocationDtos =
                listLocations
                        ?.filter { it.breitengrad != null && it.laengengrad != null ***REMOVED***
                        ?.map(ListLocationDto.Companion::convertFromListLocation)
                        ?: emptyList()
        return Response.ok().entity(listLocationDtos).build()
    ***REMOVED***

    data class ListLocationDto(
            var id: String? = null,
            var name: String? = "",
            var street: String? = "",
            var number: String? = "",
            var latitude: Double? = null,
            var longitude: Double? = null) {

        companion object {
            fun convertFromListLocation(listLocation: ListLocation): ListLocationDto {
                return (ListLocationDto(
                        listLocation.id,
                        listLocation.name,
                        listLocation.strasse,
                        listLocation.nr,
                        listLocation.laengengrad,
                        listLocation.breitengrad))
            ***REMOVED***
        ***REMOVED***
    ***REMOVED***
***REMOVED***