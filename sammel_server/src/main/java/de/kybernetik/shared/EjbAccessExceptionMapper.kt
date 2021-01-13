package de.kybernetik.shared

import org.jboss.logging.Logger
import de.kybernetik.rest.RestFehlermeldung
import javax.ejb.EJBAccessException
import javax.ejb.EJBException
import javax.ws.rs.core.Response
import javax.ws.rs.core.Response.Status.FORBIDDEN
import javax.ws.rs.core.Response.Status.INTERNAL_SERVER_ERROR
import javax.ws.rs.ext.ExceptionMapper
import javax.ws.rs.ext.Provider

@Provider
class EjbAccessExceptionMapper : ExceptionMapper<EJBException?> {
    private val LOG = Logger.getLogger(EjbAccessExceptionMapper::class.java)

    override
    fun toResponse(exception: EJBException?): Response {
        if (exception is EJBAccessException) {
            LOG.warn("Unbefugter Zugriff: ${exception.localizedMessage***REMOVED***")
            return Response.status(FORBIDDEN)
                .entity(RestFehlermeldung("Du hast nicht die notwendigen Rechte um diese Funktion auszuführen"))
                .build()
        ***REMOVED*** else {
            LOG.error("EJB-Exception aufgetreten", exception)
            return Response.status(INTERNAL_SERVER_ERROR)
                .entity(RestFehlermeldung("Ein unerwarteter Fehler ist aufgetreten: ${exception!!.localizedMessage***REMOVED***"))
                .build()
        ***REMOVED***
    ***REMOVED***
***REMOVED***