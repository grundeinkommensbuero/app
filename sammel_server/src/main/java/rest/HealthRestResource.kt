package rest

import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Response

@Path("health")
open class HealthRestResource {

    @GET
    @Produces("application/json")
    open fun health(): Response {
        return Response
                .ok()
                .entity(Health(status = "lebendig", version = "Alpha-1.0"))
                .build()

    ***REMOVED***
***REMOVED***

data class Health(val status: String, val version: String)