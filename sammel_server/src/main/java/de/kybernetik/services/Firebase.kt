package de.kybernetik.services

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.messaging.*
import org.jboss.logging.Logger
import java.io.FileInputStream
import java.io.IOException
import javax.annotation.PostConstruct
import javax.ejb.Singleton
import javax.ejb.Startup


@Startup
@Singleton
open class Firebase {
    private val LOG = Logger.getLogger(Firebase::class.java)
    private var initialized = false

    @PostConstruct
    @Suppress("unused")
    open fun initializeFirebase() {
        try {
        val creds =
            FileInputStream("/opt/shared/secrets/sammel-app-firebase-adminsdk.json")

            FirebaseApp.initializeApp(
                FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(creds))
                    .setDatabaseUrl("https://sammel-app.firebaseio.com")
                    .build()
            )
            initialized = true
            LOG.info("Firebase wurde initialisiert für ${FirebaseApp.DEFAULT_APP_NAME***REMOVED***")
        ***REMOVED*** catch (e: IOException) {
            LOG.warn("Firebase konnte nicht initialisiert werden: ${e.message***REMOVED***. Möglicherweise liegen die API-Keys nicht vor")
        ***REMOVED***
    ***REMOVED***

    open fun send(message: Message): String {
        if (initialized)
            return FirebaseMessaging.getInstance().send(message)
        LOG.warn("Nachricht konnte nicht an Firebase versendet werden, weil Firebase nicht initialisiert wurde")
        return ""
    ***REMOVED***

    open fun sendMulticast(message: MulticastMessage?): BatchResponse? {
        if (initialized)
            return FirebaseMessaging.getInstance().sendMulticast(message)
        LOG.warn("Nachricht konnte nicht an Firebase versendet werden, weil Firebase nicht initialisiert wurde")
        return null
    ***REMOVED***
***REMOVED***