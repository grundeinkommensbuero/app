package database.termine

import TestdatenVorrat.Companion.infoveranstaltung
import TestdatenVorrat.Companion.karl
import TestdatenVorrat.Companion.nordkiez
import TestdatenVorrat.Companion.rosa
import TestdatenVorrat.Companion.sammeltermin
import TestdatenVorrat.Companion.treptowerPark
import com.nhaarman.mockitokotlin2.*
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.*
import org.mockito.ArgumentMatchers.any
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.time.LocalDateTime
import javax.persistence.EntityManager
import javax.persistence.TypedQuery
import kotlin.test.assertEquals

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
    fun getTermineLiefertTermineAusDb() {
        val termin1 = Termin(1, beginn, ende, nordkiez(), sammeltermin(), emptyList())
        val termin2 = Termin(2, beginn, ende, treptowerPark(), infoveranstaltung(), listOf(rosa(), karl()))
        val termineInDb = listOf(termin1,termin2)
        whenever(entityManager.createQuery(anyString(), any<Class<Termin>>()))
                .thenReturn(typedQuery)
        whenever(typedQuery.setParameter(anyString(), anyOrNull()))
                .thenReturn(typedQuery)
        whenever(typedQuery.resultList)
                .thenReturn(termineInDb)

        val termine = dao.getTermine()

        assertEquals(termine.size, 2)
        assertEquals(termine[0], termin1)
        assertEquals(termine[1], termin2)
        assertEquals(termine[1].teilnehmer.size, 2)
        assertEquals(termine[1].teilnehmer[0].name, rosa().name)
        assertEquals(termine[1].teilnehmer[1].name, karl().name)
    ***REMOVED***

    @Test
    fun getTerminLiefertTerminAusDb() {
        val terminInDb = Termin(1, beginn, ende, nordkiez(), sammeltermin(), emptyList())
        whenever(entityManager.find(any<Class<Termin>>(), anyLong()))
                .thenReturn(terminInDb)

        val termine = dao.getTermin(1L)

        assertEquals(termine, terminInDb)
    ***REMOVED***

    @Test
    fun aktualisiereTerminSchreibtTerminInDb() {
        val termin = Termin(1, beginn, ende, nordkiez(), sammeltermin(), emptyList())

        dao.aktualisiereTermin(termin)

        verify(entityManager, atLeastOnce()).merge(termin)
        verify(entityManager, atLeastOnce()).flush()
    ***REMOVED***

    @Test
    fun erstelleNeuenTerminSchreibtTerminInDb() {
        val termin = Termin(1, beginn, ende, nordkiez(), sammeltermin(), emptyList())

        dao.erstelleNeuenTermin(termin)

        verify(entityManager, atLeastOnce()).persist(termin)
        verify(entityManager, atLeastOnce()).flush()
    ***REMOVED***
***REMOVED***