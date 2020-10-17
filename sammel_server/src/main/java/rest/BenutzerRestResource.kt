package rest

import database.benutzer.BenutzerDao
import database.benutzer.Credentials
import shared.Security
import java.lang.Exception
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ws.rs.*
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response

@Path("benutzer")
open class BenutzerRestResource {

    @EJB
    private lateinit var dao: BenutzerDao

    @EJB
    private lateinit var security: Security

    @POST
    @Path("neu")
    @RolesAllowed("app")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    open fun legeNeuenBenutzerAn(login: Login): Response {
        val benutzer = login.user
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        if (login.firebaseKey.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Firebase Key darf nicht leer sein"))
                    .build()
        }

        // Zum Vermeiden optisch ähnlicher Namen
        login.user.name = login.user.name?.trim()

        if (benutzer.name != null && dao.benutzernameExistiert(benutzer.name!!)) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername ist bereits vergeben"))
                    .build()
        }

        try {
            val benutzerAusDb = dao.legeNeuenBenutzerAn(benutzer.convertToBenutzer())

            val hashMitSalt = security.hashSecret(login.secret!!)
            dao.legeNeueCredentialsAn(Credentials(
                    benutzerAusDb.id,
                    hashMitSalt.hash,
                    hashMitSalt.salt,
                    login.firebaseKey!!,
                    listOf("app", "user")))

            return Response.ok().entity(benutzerAusDb).build()
        } catch (e: Exception) {
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        }
    }

    @POST
    @Path("authentifiziere")
    @RolesAllowed("user")
    @Produces(APPLICATION_JSON)
    open fun authentifiziereBenutzer(login: Login): Response {
        return Response
                .ok()
                .entity(true)
                .build()
    }
}