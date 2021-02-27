package de.kybernetik.database.termine

import TestdatenVorrat.Companion.infoveranstaltung
import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.sammeltermin
import TestdatenVorrat.Companion.terminDetails
import com.nhaarman.mockitokotlin2.*
import de.kybernetik.database.DatabaseException
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.*
import org.mockito.ArgumentMatchers.any
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.TermineFilter
import de.kybernetik.shared.toDate
import org.junit.Ignore
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class TermineDaoTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager

    @Mock
    private lateinit var typedQuery: TypedQuery<Termin>

    @InjectMocks
    private lateinit var dao: TermineDao

    private val beginn = LocalDateTime.of(2019, 10, 22, 14, 0, 0)
    private val ende = LocalDateTime.of(2019, 10, 22, 18, 0, 0)

    @Test
    fun getTermineLiefertAlleTermineAusDbMitLeeremFilter() {
        val termin1 = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Alee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )
        val termin2 = Termin(
            2,
            beginn,
            ende,
            "Plänterwald",
            infoveranstaltung(),
            listOf(rosa(), karl()),
            52.48612,
            13.47192,
            terminDetails()
        )
        val termineInDb = listOf(termin1, termin2)
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>()))
            .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
            .thenReturn(termineInDb)

        val termine = dao.getTermine(TermineFilter(), 0L)

        assertEquals(termine.size, 2)
        assertEquals(termine[0], termin1)
        assertEquals(termine[1], termin2)
        assertEquals(termine[1].teilnehmer.size, 2)
        assertEquals(termine[1].teilnehmer[0].name, rosa().name)
        assertEquals(termine[1].teilnehmer[1].name, karl().name)
        assertEquals(termine[1].teilnehmer[1].name, karl().name)
        assertEquals(termine[1].latitude, 52.48612)
        assertEquals(termine[1].longitude, 13.47192)
    }

    @Ignore("Funktion bis zum Release auskommentiert")
    @Test
    fun erzeugeGetTermineQueryFragtNurAktionenBisVor7Tagen() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(
            TermineFilter(emptyList(), emptyList(), null, null, emptyList()), null
        )

        val vor7tagen = LocalDate.now().minusDays(7)
        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, times(1)).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.firstValue.contains("DATE(termine.ende) > (:vor7Tagen)"))
        val datumCaptor = ArgumentCaptor.forClass(LocalDate::class.java)
        verify(typedQuery, atLeastOnce()).setParameter(matches("vor7Tagen"), datumCaptor.capture())
        assertEquals(datumCaptor.value.year, vor7tagen.year)
        assertEquals(datumCaptor.value.month, vor7tagen.month)
        assertEquals(datumCaptor.value.dayOfMonth, vor7tagen.dayOfMonth)
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztTypenKlauselWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(
            TermineFilter(listOf("Sammeln", "Infoveranstaltung"), emptyList(), null, null, emptyList()), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue { queryCaptor.firstValue.contains("where termine.typ in (:typen)") }
        val typenCaptor = ArgumentCaptor.forClass(List::class.java)
        verify(typedQuery, atLeastOnce()).setParameter(matches("typen"), typenCaptor.capture())
        assertTrue(typenCaptor.value.contains("Sammeln"))
        assertTrue(typenCaptor.value.contains("Infoveranstaltung"))
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztTypenKlauselNICHTWennNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(TermineFilter(), null)

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertFalse(queryCaptor.value.contains("where termine.typ in :typen"))
        verify(typedQuery, never()).setParameter(matches("typen"), any())
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztTageKlauselWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        val heute = LocalDate.now()
        dao.erzeugeGetTermineQuery(
            TermineFilter(emptyList(), listOf(heute, heute.plusDays(1)), null, null, emptyList()), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.value.contains("DATE(termine.beginn) in (:tage)"))
        val tageCaptor = ArgumentCaptor.forClass(List::class.java)
        verify(typedQuery, atLeastOnce()).setParameter(matches("tage"), tageCaptor.capture())
        assertTrue(tageCaptor.value.contains(heute.toDate()))
        assertTrue(tageCaptor.value.contains(heute.plusDays(1).toDate()))
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztTageKlauselNICHTWennNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(TermineFilter(), null)

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertFalse(queryCaptor.value.contains("where DATE(termine.beginn) in (:tage)"))
        verify(typedQuery, never()).setParameter(matches("tage"), any())
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztVonKlauselWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        val jetzt = LocalTime.now()
        dao.erzeugeGetTermineQuery(
            TermineFilter(emptyList(), emptyList(), jetzt, null, emptyList()), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.value.contains("TIME(termine.beginn) >= TIME(:von)"))
        verify(typedQuery, atLeastOnce()).setParameter("von", jetzt.atDate(LocalDate.now()))
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztVonKlauselNICHTWennNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(TermineFilter(), null)

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertFalse(queryCaptor.value.contains("where TIME(termine.beginn) >= TIME(:von)"))
        verify(typedQuery, never()).setParameter(matches("von"), any())
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztBisKlauselWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        val jetzt = LocalTime.now()
        dao.erzeugeGetTermineQuery(
            TermineFilter(emptyList(), emptyList(), null, jetzt, emptyList()), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.value.contains("TIME(termine.beginn) <= TIME(:bis)"))
        verify(typedQuery, atLeastOnce()).setParameter("bis", jetzt.atDate(LocalDate.now()))
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztBisKlauselNICHTWennNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(TermineFilter(), null)

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertFalse(queryCaptor.value.contains("where TIME(termine.beginn) <= TIME(:bis)"))
        verify(typedQuery, never()).setParameter(matches("von"), any())
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztOrteKlauselWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(
            TermineFilter(emptyList(), emptyList(), null, null, listOf("Frankfurter Allee Nord")), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.value.contains("termine.ort in (:orte)"))
        val tageCaptor = ArgumentCaptor.forClass(List::class.java)
        verify(typedQuery, atLeastOnce()).setParameter(matches("orte"), tageCaptor.capture())
        assertEquals((tageCaptor.value[0] as String), "Frankfurter Allee Nord")
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztOrteKlauselNICHTWennNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(TermineFilter(), null)

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertFalse(queryCaptor.value.contains("where termine.ort in (:orte)"))
        verify(typedQuery, never()).setParameter(matches("orte"), any())
    }

    @Test
    fun erzeugeGetTermineQueryErgaenztAlleKlauselnWennNichtNull() {
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>())).thenReturn(typedQuery)

        dao.erzeugeGetTermineQuery(
            TermineFilter(
                listOf("Sammeln"),
                listOf(LocalDate.of(2019, 11, 18)),
                LocalTime.of(12, 0, 0),
                LocalTime.of(18, 0, 0),
                listOf("Frankfurter Allee Nord")
            ), null
        )

        val queryCaptor = ArgumentCaptor.forClass(String::class.java)
        verify(entityManager, atLeastOnce()).createQuery(queryCaptor.capture(), any<Class<Termin>>())
        assertTrue(queryCaptor.value.contains("termine.typ in (:typen)"))
        assertTrue(queryCaptor.value.contains("DATE(termine.beginn) in (:tage)"))
        assertTrue(queryCaptor.value.contains("TIME(termine.beginn) >= TIME(:von)"))
        assertTrue(queryCaptor.value.contains("TIME(termine.beginn) <= TIME(:bis)"))
        assertTrue(queryCaptor.value.contains("termine.ort in (:orte)"))
        verify(typedQuery, atLeastOnce()).setParameter(matches("typen"), any())
        verify(typedQuery, atLeastOnce()).setParameter(matches("tage"), any())
        verify(typedQuery, atLeastOnce()).setParameter(matches("von"), any())
        verify(typedQuery, atLeastOnce()).setParameter(matches("bis"), any())
        verify(typedQuery, atLeastOnce()).setParameter(matches("orte"), any())
    }

    @Test
    fun getTerminLiefertTerminMitDetailsAusDb() {
        val terminInDb = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )
        whenever(entityManager.find(any<Class<Termin>>(), anyLong()))
            .thenReturn(terminInDb)

        val termin = dao.getTermin(1L)

        assertEquals(termin, terminInDb)
        assertEquals(termin!!.details, terminInDb.details)
    }

    @Test
    fun aktualisiereTerminSchreibtTerminInDb() {
        val termin = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )

        dao.aktualisiereTermin(termin)

        verify(entityManager, atLeastOnce()).merge(termin)
        verify(entityManager, atLeastOnce()).flush()
    }

    @Test(expected = DatenkonsistenzException::class)
    fun `aktualisiereTerminSchreibt ueberprueft ob Termin-ID und TerminDetails-ID uebereinstimmen`() {
        val termin = Termin(
            2,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )

        dao.aktualisiereTermin(termin)

        verify(entityManager, never()).merge(termin)
    }

    @Test
    fun erstelleNeuenTerminSchreibtTerminInDb() {
        val termin = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )

        dao.erstelleNeuenTermin(termin)

        verify(entityManager, atLeastOnce()).persist(termin)
        verify(entityManager, atLeastOnce()).flush()
    }

    @Test
    fun loescheAktionRemovesActionInDb() {
        val termin = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord2",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )
        val terminFromDb = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )

        whenever(entityManager.find(Termin::class.java, 1L)).thenReturn(terminFromDb)

        dao.loescheAktion(termin)

        verify(entityManager, atLeastOnce()).find(Termin::class.java, 1L)
        verify(entityManager, atLeastOnce()).remove(terminFromDb)
        verify(entityManager, atLeastOnce()).flush()
    }

    @Test(expected = DatabaseException::class)
    fun loescheAktionThrowsNotFoundExceptionIfActionDoesNotExist() {
        val termin = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )

        whenever(entityManager.find(Termin::class.java, 1L)).thenThrow(IllegalArgumentException())

        dao.loescheAktion(termin)
    }

    @Test(expected = DatabaseException::class)
    fun loescheAktionThrowsNotFoundExceptionIfDeletionFails() {
        val termin = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord2",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )
        val actionFromDb = Termin(
            1,
            beginn,
            ende,
            "Frankfurter Allee Nord",
            sammeltermin(),
            emptyList(),
            52.48612,
            13.47192,
            terminDetails()
        )
        whenever(entityManager.find(Termin::class.java, 1L)).thenReturn(actionFromDb)
        whenever(entityManager.remove(actionFromDb)).thenThrow(IllegalArgumentException())

        dao.loescheAktion(termin)
    }

    @Test
    fun loadTokenLoadsTokenForActionIdFromDb() {
        whenever(entityManager.find(Token::class.java, 12L)).thenReturn(Token(12L, "token"))

        val token = dao.loadToken(12L)

        assertEquals(token!!.actionId, 12L)
        assertEquals(token.token, "token")
    }
}