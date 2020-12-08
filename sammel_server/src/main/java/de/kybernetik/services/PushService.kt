package de.kybernetik.services

import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.rest.PushNotificationDto
import org.jboss.logging.Logger
import javax.ejb.EJB
import javax.ejb.Singleton
import javax.ejb.Startup


@Startup
@Singleton
open class PushService {
    private val LOG = Logger.getLogger(PushService::class.java)

    @EJB
    private lateinit var firebase: FirebaseService

    @EJB
    private lateinit var pushDao: PushMessageDao

    @EJB
    private lateinit var benutzerDao: BenutzerDao

    open fun sendePushNachrichtAnEmpfaenger(
        notification: PushNotificationDto?,
        data: Map<String, String>?,
        empfaenger: List<Benutzer>
    ) {
        val firebaseKeys = benutzerDao.getFirebaseKeys(empfaenger)
        val benutzerOhneFirebase = benutzerDao.getBenutzerOhneFirebase(empfaenger)

        if (firebaseKeys.size > 0)
            firebase.sendePushNachrichtAnEmpfaenger(notification, data, firebaseKeys)
        if (benutzerOhneFirebase.size > 0)
            pushDao.speicherePushMessageFuerEmpfaenger(notification, data, benutzerOhneFirebase)
    ***REMOVED***
***REMOVED***