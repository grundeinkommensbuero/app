package de.kybernetik.rest

import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.benutzer.Credentials
import de.kybernetik.database.subscriptions.SubscriptionDao
import org.jboss.logging.Logger
import de.kybernetik.shared.Security
import java.lang.Exception
import javax.annotation.security.RolesAllowed
import javax.ejb.EJB
import javax.ejb.Stateless
import javax.transaction.Transactional
import javax.ws.rs.*
import javax.ws.rs.core.Context
import javax.ws.rs.core.MediaType.APPLICATION_JSON
import javax.ws.rs.core.Response
import javax.ws.rs.core.SecurityContext

@Path("benutzer")
@Stateless
open class BenutzerRestResource {

    @Context
    private lateinit var context: SecurityContext

    @EJB
    private lateinit var dao: BenutzerDao

    @EJB
    private lateinit var subscriptinDao: SubscriptionDao

    @EJB
    private lateinit var security: Security

    private val _log = Logger.getLogger(this::class.java)

    @POST
    @Path("neu")
    @RolesAllowed("app")
    @Consumes(APPLICATION_JSON)
    @Produces(APPLICATION_JSON)
    @Transactional
    open fun legeNeuenBenutzerAn(login: Login): Response {
        val benutzer = login.user
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
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

            var isFirebase = true
            if (login.firebaseKey.isNullOrEmpty()) {
                login.firebaseKey = NO_FIREBASE
                isFirebase = false
            }

            dao.legeNeueCredentialsAn(Credentials(
                    benutzerAusDb.id,
                    hashMitSalt.hash,
                    hashMitSalt.salt,
                    login.firebaseKey!!,
                    isFirebase,
                    listOf("app", "user")))

            subscriptinDao.subscribe(benutzerAusDb.id, listOf("global"))

            return Response.ok().entity(benutzerAusDb).build()
        } catch (e: Exception) {
            _log.error("Fehler beim Anlegen eines Benutzers: $benutzer", e)
            return Response
                    .status(500)
                    .entity(RestFehlermeldung("Ein technisches Problem ist aufgetreten"))
                    .build()
        }
    }

    @POST
    @Path("aktualisiereName")
    @RolesAllowed("user")
    @Produces(APPLICATION_JSON)
    open fun aktualisiereBenutzername(name: String?): Response {
        val id = context.userPrincipal.name
        _log.debug("Aktualisiere Benutzernamen von $id mit $name")
        val trimmedName = name?.trim()
        if(trimmedName.isNullOrBlank()) {
            _log.debug("Fehlender Benutzer-Name")
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzername darf nicht leer sein"))
                    .build()
        }

        val aktualisierterBenutzer = dao.aktualisiereBenutzername(id.toLong(), trimmedName)
        dao.gibNutzerNamedRolle(aktualisierterBenutzer)
        return Response
                .status(200)
                .entity(BenutzerDto.convertFromBenutzer(aktualisierterBenutzer))
                .build()
    }

    @POST
    @Path("authentifiziere")
    @RolesAllowed("app")
    @Produces(APPLICATION_JSON)
    open fun authentifiziereBenutzer(login: Login): Response {
        val benutzer = login.user
        if (benutzer.id == null) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID darf nicht leer sein"))
                    .build()
        }
        if (login.secret.isNullOrEmpty()) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Secret darf nicht leer sein"))
                    .build()
        }
        val credentials: Credentials?
        try {
            credentials = dao.getCredentials(benutzer.id!!)
        } catch (e: java.lang.IllegalArgumentException) {
            return Response
                    .status(412)
                    .entity(RestFehlermeldung("Benutzer-ID ist ungültig"))
                    .build()
        }
        if (credentials == null) {
            _log.info("Login mit unbekanntem Benutzer ${login.user.id}")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        }
        _log.trace(credentials.roles)
        val verifiziert: Boolean?
        try {
            verifiziert = security.verifiziereSecretMitHash(login.secret!!, Security.HashMitSalt(credentials.secret, credentials.salt))
        } catch (e: Exception) {
            val meldung = "Technischer Fehler beim Verifizieren: ${e.localizedMessage}"
            _log.info(meldung)
            return Response.status(500).entity(RestFehlermeldung(meldung)).build()
        }

        if (!verifiziert) {
            _log.info("Falscher Login mit Benutzer ${login.user.id}")
            return Response
                    .ok()
                    .entity(false)
                    .build()
        }
        return Response
                .ok()
                .entity(true)
                .build()
    }

    companion object {
        const val NO_FIREBASE = "none"
    }
}