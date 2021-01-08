package de.kybernetik.rest

import javax.annotation.security.PermitAll
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Response

@Path("health")
open class HealthRestResource {

    @GET
    @PermitAll
    @Produces("application/json")
    open fun health(): Response {
        return Response
                .ok()
                .entity(Health(status = "lebendig", version = "0.4.0", minClient = "0.4.0+18"))
                .build()

    }
}

data class Health(val status: String, val version: String, val minClient: String)