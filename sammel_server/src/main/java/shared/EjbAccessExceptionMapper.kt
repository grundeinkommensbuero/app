package shared

import javax.ejb.EJBException
import javax.ws.rs.core.Response
import javax.ws.rs.core.Response.Status.FORBIDDEN
import javax.ws.rs.ext.ExceptionMapper
import javax.ws.rs.ext.Provider

@Provider
class EjbAccessExceptionMapper : ExceptionMapper<EJBException?> {
    override
    fun toResponse(exception: EJBException?): Response {
        return Response.status(FORBIDDEN).entity("Du hast nicht die notwendigen Rechte um diese Funktion auszuführen").build()
    ***REMOVED***
***REMOVED***