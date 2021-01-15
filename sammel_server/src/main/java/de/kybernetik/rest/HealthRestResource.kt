package de.kybernetik.rest

import javax.annotation.security.PermitAll
import javax.ejb.Stateless
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Response

@Path("health")
@Stateless
open class HealthRestResource {

    @GET
    @PermitAll
    @Produces("application/json")
    open fun health(): Response {
        return Response
                .ok()
                .entity(Health(status = "lebendig", version = "0.5.0", minClient = "0.4.0+18"))
                .build()

    ***REMOVED***
***REMOVED***

data class Health(val status: String, val version: String, val minClient: String)