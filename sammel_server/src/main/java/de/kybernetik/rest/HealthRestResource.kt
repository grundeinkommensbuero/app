package de.kybernetik.rest

import de.kybernetik.database.faq.FAQDao
import java.lang.System.getProperty
import java.time.LocalDateTime
import javax.annotation.security.PermitAll
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.Response

@Path("health")
@Stateless
open class HealthRestResource {

    @EJB
    private lateinit var faqDao: FAQDao

    @GET
    @PermitAll
    @Produces("application/json")
    open fun health(): Response {
        return Response
            .ok()
            .entity(
                Health(
                    status = "lebendig",
                    version = "1.4.4",
                    minClient = "1.2.0+29",
                    modus = getProperty("mode"),
                    faqTimestamp = faqDao.getFAQTimestamp()
                )
            )
            .build()

    ***REMOVED***
***REMOVED***

data class Health(
    val status: String,
    val version: String,
    val minClient: String,
    val modus: String?,
    val faqTimestamp: LocalDateTime?
)