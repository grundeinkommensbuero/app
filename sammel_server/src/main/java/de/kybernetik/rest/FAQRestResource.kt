package de.kybernetik.rest

import de.kybernetik.database.faq.FAQ
import de.kybernetik.database.faq.FAQDao
import org.jboss.logging.Logger
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.ws.rs.Consumes
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType

@Path("faq")
@Stateless
open class FAQRestResource {
    private val LOG = Logger.getLogger(FAQRestResource::class.java)

    @EJB
    private lateinit var dao: FAQDao

    @GET
    @RolesAllowed("app")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    open fun getAllFAQs(): List<FAQDto> {
        LOG.info("Lade FAQs")
        return dao.getAllFAQ().map { FAQDto.convertFromFAQ(it) }
    }
}

data class FAQDto(
    var id: Long,
    var title: String,
    var teaser: String,
    var rest: String? = null,
    var order: Double? = null,
    var tags: List<String>? = null
) {
    companion object {
        fun convertFromFAQ(faq: FAQ): FAQDto = FAQDto(faq.id, faq.title, faq.teaser, faq.rest, faq.order, faq.tags)
    }
}