package de.kybernetik.database.vorbehalte

import com.nhaarman.mockitokotlin2.argumentCaptor
import com.nhaarman.mockitokotlin2.atLeastOnce
import com.nhaarman.mockitokotlin2.verify
import org.junit.Test

import org.junit.Assert.*
import org.junit.Rule
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import java.time.LocalDate
import java.util.Calendar.AUGUST
import javax.persistence.EntityManager
import kotlin.math.absoluteValue

class VorbehalteDaoTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var entityManager: EntityManager

    @InjectMocks
    private lateinit var dao: VorbehalteDao

    @Test
    fun erzeugeNeueVorbehalteLegtVorbehalteInDbAb() {
        dao.erzeugeNeueVorbehalte(Vorbehalte(0, "Neubau (2), Kosten", 11, LocalDate.of(2021,8,8), "Frankfurter Allee Nord"))

        val captor = argumentCaptor<Vorbehalte>()
        verify(entityManager, atLeastOnce()).persist(captor.capture())
        val argument = captor.firstValue
        assertEquals(0, argument.id)
        assertEquals("Neubau (2), Kosten", argument.vorbehalte)
        assertEquals(11, argument.benutzer)
        assertEquals("Frankfurter Allee Nord", argument.ort)
        assertEquals(2021, argument.datum?.year)
        assertEquals(8,argument.datum?.month?.value)
        assertEquals(8, argument.datum?.dayOfMonth)
    ***REMOVED***
***REMOVED***