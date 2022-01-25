package de.kybernetik.rest

import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.benutzer.Benutzer
import de.kybernetik.database.benutzer.BenutzerDao
import de.kybernetik.database.benutzer.Credentials
import de.kybernetik.database.subscriptions.SubscriptionDao
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.shared.Security
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Ignore
import java.lang.IllegalArgumentException
import java.sql.SQLException
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class BenutzerRestResourceTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: BenutzerDao

    @Mock
    private lateinit var security: Security

    @Mock
    private lateinit var context: SecurityContext

    @Suppress("unused")
    @Mock
    private lateinit var subscriptinDao: SubscriptionDao

    @InjectMocks
    private lateinit var resource: BenutzerRestResource

    @Before
    fun setUp() {
        whenever(security.hashSecret(any())).thenReturn(Security.HashMitSalt("hash", "salt"))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("1"))
    }

    @Test
    fun `legeNeuenBenutzerAn erwartet secret`() {
        val response = resource.legeNeuenBenutzerAn(Login("", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Secret darf nicht leer sein")
    }

    @Test
    fun `legeNeuenBenutzerAn markiert Credentials ohne Firebase-Key`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "", BenutzerDto(11L, "Karl Marx", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        assertEquals(captor.firstValue.firebaseKey, BenutzerRestResource.NO_FIREBASE)
        assertEquals(captor.firstValue.isFirebase, false)
    }

    @Ignore("ausgebautes Feature")
    @Test
    fun `legeNeuenBenutzerAn lehnt bereits bestehende Benutzernamen ab`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(true)

        val response = resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzername ist bereits vergeben")
    }

    @Test
    fun `legeNeuenBenutzerAn prueft Nahmensaehnlichkeit nicht bei fehlendem Namen`() {
        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, null)))

        verify(dao, never()).benutzernameExistiert(anyString())
    }

    @Test
    fun `legeNeuenBenutzerAn erzeugt neuen Benutzer in Datenbank`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer())

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        verify(dao, times(1)).legeNeuenBenutzerAn(any())
    }

    @Ignore("auskommentiertes Feature")
    @Test
    fun `legeNeuenBenutzerAn entfernt Leerzeichen vor und hinter Benutzername`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer())

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Benutzer>()
        verify(dao, times(1)).legeNeuenBenutzerAn(captor.capture())
        assertEquals("Karl Marx", captor.firstValue.name)
    }

    @Test
    fun `legeNeuenBenutzerAn erzeugt Credentials fuer Benutzer mit Firebase-Key`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        assertEquals(captor.firstValue.id, 11L)
        assertEquals(captor.firstValue.firebaseKey, "AAAAAAAA")
        assertNotNull(captor.firstValue.salt)
        assertNotNull(captor.firstValue.secret)
        assertTrue(captor.firstValue.isFirebase)
    }

    @Test
    fun `legeNeuenBenutzerAn hasht Secret und speichert gehashtes Secret mit Salt in Datenbank`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        verify(security, times(1)).hashSecret("11111111")

        assertEquals(captor.firstValue.secret, "hash")
        assertEquals(captor.firstValue.salt, "salt")
    }

    @Test
    fun `legeNeuenBenutzerAn gibt Benutzer Rollen`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        assertTrue(captor.firstValue.roles.contains("app"))
        assertTrue(captor.firstValue.roles.contains("user"))
    }

    @Test
    fun `authentifiziereBenutzer erwartet Id`() {
        val response = resource.authentifiziereBenutzer(Login("11111111", "AAAAAAAA", BenutzerDto(null, null)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzer-ID darf nicht leer sein")
    }

    @Test
    fun `authentifiziereBenutzer erwartet gueltige Id`() {
        whenever(dao.getCredentials(-1L)).thenThrow(IllegalArgumentException())
        val response = resource.authentifiziereBenutzer(Login("11111111", "AAAAAAAA", BenutzerDto(-1L, null)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzer-ID ist ungültig")
    }

    @Test
    fun `authentifiziereBenutzer erwartet secret`() {
        val response = resource.authentifiziereBenutzer(Login("", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Secret darf nicht leer sein")
    }

    @Test
    fun `authentifiziereBenutzer lehnt falsches Secret ab`() {
        whenever(dao.getCredentials(11L)).thenReturn(Credentials(11L, "hash", "salt", "Firebase-Key", true, emptyList()))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(false)

        val response = resource.authentifiziereBenutzer(Login("falsch", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        verify(security, times(1)).verifiziereSecretMitHash(anyString(), any())
        assertEquals(response.status, 200)
        assertEquals(response.entity, false)
    }

    @Test
    fun `authentifiziereBenutzer weist unbekannte Benutzer zurueck`() {
        whenever(dao.getCredentials(11L)).thenReturn(null)
        val response = resource.authentifiziereBenutzer(Login("falsch", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(response.status, 200)
        assertEquals(response.entity, false)
    }

    @Test
    fun `authentifiziereBenutzer akzeptiert korrektes Secret`() {
        whenever(dao.getCredentials(11L)).thenReturn(Credentials(11L, "hash", "salt", "Firebase-Key", true, emptyList()))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)

        val response = resource.authentifiziereBenutzer(Login("richtig", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        verify(security, times(1)).verifiziereSecretMitHash(anyString(), any())
        assertEquals(response.status, 200)
    }

    @Test
    fun `authentifiziereBenutzer tauscht Firebas-Key aus, wenn er nicht uebereinstimmt`() {
        val credentials = Credentials(11L, "hash", "salt", "alter Firebase-Key", true, emptyList())
        whenever(dao.getCredentials(11L)).thenReturn(credentials)
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)
        assertEquals(credentials.firebaseKey, "alter Firebase-Key")

        resource.authentifiziereBenutzer(Login("richtig", "neuer Firebase-Key", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(credentials.firebaseKey, "neuer Firebase-Key")
    }

    @Test
    fun `authentifiziereBenutzer ergaenzt Firebas-Key wenn keiner hinterlegt ist`() {
        val credentials = Credentials(11L, "hash", "salt", "none", true, emptyList())
        whenever(dao.getCredentials(11L)).thenReturn(credentials)
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)
        assertEquals(credentials.firebaseKey, "none")

        resource.authentifiziereBenutzer(Login("richtig", "neuer Firebase-Key", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(credentials.firebaseKey, "neuer Firebase-Key")
    }

    @Test
    fun `authentifiziereBenutzer ersetzt echten Firebas-Key nicht, wenn neuer Key null ist`() {
        val credentials = Credentials(11L, "hash", "salt", "alter Firebase-Key", true, emptyList())
        whenever(dao.getCredentials(11L)).thenReturn(credentials)
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)
        assertEquals(credentials.firebaseKey, "alter Firebase-Key")

        resource.authentifiziereBenutzer(Login("richtig", null, BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(credentials.firebaseKey, "alter Firebase-Key")
    }

    @Test
    fun `aktualisiereBenutzername weist leeren Namen zurueck`() {
        var response = resource.aktualisiereBenutzername(null)
        assertEquals(response.status, 412)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzername darf nicht leer sein")

        response = resource.aktualisiereBenutzername("")
        assertEquals(response.status, 412)

        response = resource.aktualisiereBenutzername("   ")
        assertEquals(response.status, 412)
    }

    @Test
    fun `aktualisiereBenutzername reicht Benutzer zum speichern in DB weiter`() {
        val name = "ein neuer Name"
        val karl = Benutzer(1, "ein neuer Name", color = 12345678)
        whenever(dao.aktualisiereBenutzername(1L, name)).thenReturn(karl)

        val response = resource.aktualisiereBenutzername(name)

        verify(dao, times(1)).aktualisiereBenutzername(1L, name)
        assertEquals(name, (response.entity as BenutzerDto).name)
        assertEquals(1L, (response.entity as BenutzerDto).id)
    }

    @Test
    fun `aktualisiereBenutzername vergibt Rolle wenn alles klappt`() {
        val name = "ein neuer Name"
        val karl = Benutzer(1, "ein neuer Name", color = 12345678)
        whenever(dao.aktualisiereBenutzername(1L, name)).thenReturn(karl)

        resource.aktualisiereBenutzername(name)

        verify(dao, times(1)).gibNutzerNamedRolle(karl)
    }

    @Test
    fun `aktualisiereBenutzername vergibt Rolle _nicht_ bei Fehler`() {
        val name = "ein neuer Name"
        val karl = Benutzer(1, "ein neuer Name", color = 12345678)
        whenever(dao.aktualisiereBenutzername(1L, name)).then { throw SQLException() }

        try {
            resource.aktualisiereBenutzername(name)
        } catch(e: SQLException) {}

        verify(dao, never()).gibNutzerNamedRolle(karl)
    }
}
