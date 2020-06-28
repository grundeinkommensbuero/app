package services

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.messaging.FirebaseMessaging
import org.jboss.logging.Logger
import java.io.FileInputStream
import javax.annotation.PostConstruct
import javax.ejb.Singleton
import javax.ejb.Startup


@Startup
@Singleton
open class Firebase() {
    private val LOG = Logger.getLogger(Firebase::class.java)

    @PostConstruct
    @Suppress("unused")
    open fun initializeFirebase() {
        val creds = FileInputStream("${System.getenv("JBOSS_HOME")}/standalone/configuration/sammel-app-firebase-adminsdk.json")

        FirebaseApp.initializeApp(FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(creds))
                .setDatabaseUrl("https://sammel-app.firebaseio.com")
                .build())
        LOG.info("Firebase wurde intialisiert für ${FirebaseApp.DEFAULT_APP_NAME}")
    }

    open fun instance(): FirebaseMessaging = FirebaseMessaging.getInstance()

}