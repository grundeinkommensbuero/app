package rest

import com.nhaarman.mockitokotlin2.whenever
import database.benutzer.Benutzer
import database.benutzer.BenutzerDao
import org.hamcrest.CoreMatchers
import org.junit.Assert.*
import org.junit.Rule
import org.junit.Test
import org.mockito.ArgumentMatchers.anyString
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule

class BenutzerRestResourceTest {

    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    private lateinit var dao: BenutzerDao


    @InjectMocks
    private lateinit var benutzerRest: BenutzerRestResource

    @Test
    fun getBenutzerWirft412BeiFehlendemNamen() {

        val response = benutzerRest.getBenutzer("")

        assertEquals(response.status, 412)
        assertThat(response.entity, CoreMatchers.instanceOf(RestFehlermeldung::class.java))
        val fehlermeldung = response.entity as RestFehlermeldung
        assertFalse(fehlermeldung.meldung.isNullOrEmpty())
    }

    @Test
    fun getBenutzerWirft404BeiUnbekanntemBenutzer() {
        whenever(dao.getBenutzer(anyString())).thenReturn(null)

        val response = benutzerRest.getBenutzer("Antonio Gramasci")

        assertEquals(response.status, 404)
        assertThat(response.entity, CoreMatchers.instanceOf(RestFehlermeldung::class.java))
        val fehlermeldung = response.entity as RestFehlermeldung
        assertFalse(fehlermeldung.meldung.isNullOrEmpty())
    }

    @Test
    fun getBenutzerWirftServerFehlerBeiDoppeltemBenutzer() {
        whenever(dao.getBenutzer(anyString())).thenThrow(
                BenutzerDao.BenutzerMehrfachVorhandenException("Benutzer mehrfach vorhanden"))

        val response = benutzerRest.getBenutzer("Antonio Gramasci")

        assertEquals(response.status, 500)
        assertThat(response.entity, CoreMatchers.instanceOf(RestFehlermeldung::class.java))
        val fehlermeldung = response.entity as RestFehlermeldung
        assertFalse(fehlermeldung.meldung.isNullOrEmpty())
    }

    @Test
    fun getBenutzerLiefertBenutzerWennVorhanden() {
        val karl = Benutzer(1, "Karl Marx", "hash1", "123456789")
        whenever(dao.getBenutzer(anyString())).thenReturn(karl)

        val response = benutzerRest.getBenutzer("Antonio Gramasci")

        assertEquals(response.status, 200)
        assertSame(response.entity, karl)
    }
}
