package de.kybernetik.rest

import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.vorbehalte.Vorbehalte
import de.kybernetik.database.vorbehalte.VorbehalteDao
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Test

import org.junit.Before
import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.time.LocalDate
import javax.ws.rs.core.SecurityContext
import kotlin.test.assertEquals

class VorbehalteRestRessourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: VorbehalteDao

    @Mock
    private lateinit var context: SecurityContext

    @InjectMocks
    private lateinit var ressource: VorbehalteRestRessource

    @Before
    fun setUp() {
        whenever(context.userPrincipal).thenReturn(BasicUserPrincipal("11"))
    }

    @Test
    fun `legeNeueVorbehalteAn konvertiert Dto und ruft Dao auf`() {
        ressource.legeNeueVorbehalteAn(
            VorbehalteDto(
                0,
                "Neubau (2), Kosten",
                LocalDate.of(2021, 8, 8),
                "10243"
            )
        )

        val captor = argumentCaptor<Vorbehalte>()
        verify(dao, times(1)).erzeugeNeueVorbehalte(captor.capture())
        assertEquals(0, captor.firstValue.id)
        assertEquals("Neubau (2), Kosten", captor.firstValue.vorbehalte)
        assertEquals(11, captor.firstValue.benutzer)
        assertEquals(2021, captor.firstValue.datum?.year)
        assertEquals(8, captor.firstValue.datum?.monthValue)
        assertEquals(8, captor.firstValue.datum?.dayOfMonth)
        assertEquals("10243", captor.firstValue.ort)
    }

    @Test
    fun `legeNeueVorbehalteAn reichert um Benutzer an`() {
        val response = ressource.legeNeueVorbehalteAn(
            VorbehalteDto(
                0,
                "Neubau (2), Kosten",
                LocalDate.of(2021, 8, 8),
                "10243"
            )
        )

        val captor = argumentCaptor<Vorbehalte>()
        verify(dao).erzeugeNeueVorbehalte(captor.capture())
        assertEquals(11, captor.firstValue.benutzer)
        assertEquals(200, response.status)
    }

    @Test
    fun `legeNeueVorbehalteAn speichert bei fehlenden Werten nicht und gibt Fehlercode zurueck`() {
        val response = ressource.legeNeueVorbehalteAn(
            VorbehalteDto(
                0,
                "Neubau (2), Kosten",
                null,
                "10243"
            )
        )

        verify(dao, never()).erzeugeNeueVorbehalte(anyOrNull())
        assertEquals("Fehlender Wert für Datum", (response.entity as RestFehlermeldung).meldung)
    }
}