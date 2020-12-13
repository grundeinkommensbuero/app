package de.kybernetik.services

import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.pushmessages.PushMessageDao
import de.kybernetik.rest.PushNotificationDto
import javax.ejb.EJB
import javax.ejb.Startup
import javax.ejb.Stateless


@Startup
@Stateless
open class PushService {
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
    }
}