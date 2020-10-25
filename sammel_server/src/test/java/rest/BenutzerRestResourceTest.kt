package rest

import com.nhaarman.mockitokotlin2.*
import database.benutzer.Benutzer
import database.benutzer.BenutzerDao
import database.benutzer.Credentials
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import shared.Security
import java.lang.IllegalArgumentException
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

    @InjectMocks
    private lateinit var resource: BenutzerRestResource

    @Before
    fun setUp() {
        whenever(security.hashSecret(any())).thenReturn(Security.HashMitSalt("hash", "salt"))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn erwartet secret`() {
        val response = resource.legeNeuenBenutzerAn(Login("", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Secret darf nicht leer sein")
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn erwartet firebaseKey`() {
        val response = resource.legeNeuenBenutzerAn(Login("11111111", "", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Firebase Key darf nicht leer sein")
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn lehnt bereits bestehende Benutzernamen ab`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(true)

        val response = resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzername ist bereits vergeben")
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn prueft Nahmensaehnlichkeit nicht bei fehlendem Namen`() {
        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, null)))

        verify(dao, never()).benutzernameExistiert(anyString())
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn erzeugt neuen Benutzer in Datenbank`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer())

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "Karl Marx", 4294198070)))

        verify(dao, times(1)).legeNeuenBenutzerAn(any())
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn entfernt Leerzeichen vor und hinter Benutzername`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer())

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Benutzer>()
        verify(dao, times(1)).legeNeuenBenutzerAn(captor.capture())
        assertEquals(captor.firstValue.name, "Karl Marx")
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn erzeugt Credentials fuer Benutzer`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        assertEquals(captor.firstValue.id, 11L)
        assertEquals(captor.firstValue.firebaseKey, "AAAAAAAA")
        assertNotNull(captor.firstValue.salt)
        assertNotNull(captor.firstValue.secret)
    ***REMOVED***

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
    ***REMOVED***

    @Test
    fun `legeNeuenBenutzerAn gibt Benutzer Rollen`() {
        whenever(dao.benutzernameExistiert("Karl Marx")).thenReturn(false)
        whenever(dao.legeNeuenBenutzerAn(any())).thenReturn(Benutzer(11L, "Karl Marx", 4294198070))

        resource.legeNeuenBenutzerAn(Login("11111111", "AAAAAAAA", BenutzerDto(null, "  Karl Marx  ", 4294198070)))

        val captor = argumentCaptor<Credentials>()
        verify(dao, times(1)).legeNeueCredentialsAn(captor.capture())
        assertTrue(captor.firstValue.roles.contains("app"))
        assertTrue(captor.firstValue.roles.contains("user"))
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer erwartet Id`() {
        val response = resource.authentifiziereBenutzer(Login("11111111", "AAAAAAAA", BenutzerDto(null, null)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzer-ID darf nicht leer sein")
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer erwartet gueltige Id`() {
        whenever(dao.getCredentials(-1L)).thenThrow(IllegalArgumentException())
        val response = resource.authentifiziereBenutzer(Login("11111111", "AAAAAAAA", BenutzerDto(-1L, null)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzer-ID ist ungültig")
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer erwartet secret`() {
        val response = resource.authentifiziereBenutzer(Login("", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(response.status, 412)
        assertEquals(response.entity is RestFehlermeldung, true)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Secret darf nicht leer sein")
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer lehnt falsches Secret ab`() {
        whenever(dao.getCredentials(11L)).thenReturn(Credentials(11L, "hash", "salt", "Firebase-Key", emptyList()))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(false)

        val response = resource.authentifiziereBenutzer(Login("falsch", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        verify(security, times(1)).verifiziereSecretMitHash(anyString(), any())
        assertEquals(response.status, 200)
        assertEquals(response.entity, false)
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer weist unbekannte Benutzer zurueck`() {
        whenever(dao.getCredentials(11L)).thenReturn(null)
        val response = resource.authentifiziereBenutzer(Login("falsch", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        assertEquals(response.status, 200)
        assertEquals(response.entity, false)
    ***REMOVED***

    @Test
    fun `authentifiziereBenutzer akzeptiert korrektes Secret`() {
        whenever(dao.getCredentials(11L)).thenReturn(Credentials(11L, "hash", "salt", "Firebase-Key", emptyList()))
        whenever(security.verifiziereSecretMitHash(anyString(), any())).thenReturn(true)

        val response = resource.authentifiziereBenutzer(Login("richtig", "AAAAAAAA", BenutzerDto(11L, "Karl Marx", 4294198070)))

        verify(security, times(1)).verifiziereSecretMitHash(anyString(), any())
        assertEquals(response.status, 200)
    ***REMOVED***

    @Test
    fun `aktualisiereBenutzer weist Benutzer ohne Namen zurueck`() {
        var response = resource.aktualisiereBenutzer(BenutzerDto(1, null, color = 12345678))
        assertEquals(response.status, 412)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Benutzername darf nicht leer sein")

        response = resource.aktualisiereBenutzer(BenutzerDto(1, "", color = 12345678))
        assertEquals(response.status, 412)

        response = resource.aktualisiereBenutzer(BenutzerDto(1, "   ", color = 12345678))
        assertEquals(response.status, 412)
    ***REMOVED***

    @Test
    fun `aktualisiereBenutzer weist Benutzer ohne ID zurueck`() {
        var response = resource.aktualisiereBenutzer(BenutzerDto(0, "ein Name", color = 12345678))
        assertEquals(response.status, 412)
        assertEquals((response.entity as RestFehlermeldung).meldung, "Der Benutzer ist noch nicht angelegt")

        response = resource.aktualisiereBenutzer(BenutzerDto(null, "ein Name", color = 12345678))
        assertEquals(response.status, 412)
    ***REMOVED***

    @Test
    fun `aktualisiereBenutzer reicht Benutzer zum speichern in DB weiter`() {
        whenever(dao.aktualisiereUser(any())).thenReturn(Benutzer(1, "ein neuer Name", color = 12345678))

        val response = resource.aktualisiereBenutzer(BenutzerDto(1, "ein neuer Name", color = 12345678))

        val benutzerCaptor = argumentCaptor<Benutzer>()
        verify(dao, times(1)).aktualisiereUser(benutzerCaptor.capture())
        assertEquals(benutzerCaptor.firstValue.id, 1)
        assertEquals(benutzerCaptor.firstValue.name, "ein neuer Name")
        assertEquals(benutzerCaptor.firstValue.color, 12345678)

        assertEquals(response.status, 200)
        assertEquals((response.entity as BenutzerDto).id, 1)
        assertEquals((response.entity as BenutzerDto).name, "ein neuer Name")
        assertEquals((response.entity as BenutzerDto).color, 12345678)
    ***REMOVED***
***REMOVED***
