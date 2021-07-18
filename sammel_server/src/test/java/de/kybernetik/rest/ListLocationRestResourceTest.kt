package de.kybernetik.rest

import TestdatenVorrat.Companion.cafeKotti
import TestdatenVorrat.Companion.curry36
import TestdatenVorrat.Companion.zukunft
import com.nhaarman.mockitokotlin2.whenever
import de.kybernetik.database.listlocations.ListLocation
import de.kybernetik.database.listlocations.ListLocationDao
import org.junit.Assert.*
import org.junit.Rule
import org.junit.Test
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.MockitoJUnit
import org.mockito.junit.MockitoRule
import de.kybernetik.rest.ListLocationRestResource.ListLocationDto
import de.kybernetik.rest.ListLocationRestResource.ListLocationDto.Companion.convertFromListLocation
import org.apache.http.auth.BasicUserPrincipal
import org.junit.Before

class ListLocationRestResourceTest {
    @Rule
    @JvmField
    var mockitoRule: MockitoRule = MockitoJUnit.rule()

    @Mock
    lateinit var dao: ListLocationDao

    @InjectMocks
    private lateinit var resource: ListLocationRestResource

    @Before
    fun setUp() {
        System.setProperty("de.kybernetik.listlocations.secret", "false")
    }

    @Test
    fun `converts ListLocation to ListLocationDto`() {
        val listlocation = curry36()

        val listLocationDto: ListLocationDto = convertFromListLocation(listlocation)

        assertEquals(listLocationDto.id, curry36().id)
        assertEquals(listLocationDto.name, curry36().name)
        assertEquals(listLocationDto.street, curry36().strasse)
        assertEquals(listLocationDto.number, curry36().nr)
        assertEquals(listLocationDto.latitude, curry36().laengengrad)
        assertEquals(listLocationDto.longitude, curry36().breitengrad)
    }

    @Test
    fun `converts ListLocation to ListLocationDto with missing data`() {
        val listlocation = ListLocation(null, "", "", "", null, null)

        val listLocationDto: ListLocationDto = convertFromListLocation(listlocation)

        assertEquals(listLocationDto.id, null)
        assertEquals(listLocationDto.name, "")
        assertEquals(listLocationDto.street, "")
        assertEquals(listLocationDto.number, "")
        assertEquals(listLocationDto.latitude, null)
        assertEquals(listLocationDto.longitude, null)
    }

    @Test
    @Suppress("UNCHECKED_CAST")
    fun `getActiveListLocations returns empty list if secret`() {
        System.setProperty("de.kybernetik.listlocations.secret", "true")

        val result = resource.getActiveListLocations()
        val list: List<ListLocationDto> = result.entity as List<ListLocationDto>

        assertTrue(list.isEmpty())
    }

    @Test
    @Suppress("UNCHECKED_CAST") // Datentyp für Entity
    fun `getActiveListLocations returns results from database query`() {
        whenever(dao.getActiveListLocations()).thenReturn(listOf(curry36(), cafeKotti(), zukunft()))

        val result = resource.getActiveListLocations()
        val list: List<ListLocationDto> = result.entity as List<ListLocationDto>

        assertEquals(list.size,3)

        assertEquals(list[0].id, curry36().id)
        assertEquals(list[0].name, curry36().name)
        assertEquals(list[0].street, curry36().strasse)
        assertEquals(list[0].number, curry36().nr)
        assertEquals(list[0].latitude, curry36().laengengrad)
        assertEquals(list[0].longitude, curry36().breitengrad)

        assertEquals(list[1].id, cafeKotti().id)
        assertEquals(list[1].name, cafeKotti().name)
        assertEquals(list[1].street, cafeKotti().strasse)
        assertEquals(list[1].number, cafeKotti().nr)
        assertEquals(list[1].latitude, cafeKotti().laengengrad)
        assertEquals(list[1].longitude, cafeKotti().breitengrad)

        assertEquals(list[2].id, zukunft().id)
        assertEquals(list[2].name, zukunft().name)
        assertEquals(list[2].street, zukunft().strasse)
        assertEquals(list[2].number, zukunft().nr)
        assertEquals(list[2].latitude, zukunft().laengengrad)
        assertEquals(list[2].longitude, zukunft().breitengrad)
    }

    @Test
    @Suppress("UNCHECKED_CAST") // Datentyp für Entity
    fun `getActiveListLocations filters entries without coordinates `() {
        val lostPlace = cafeKotti()
        lostPlace.breitengrad = null
        lostPlace.laengengrad = null
        whenever(dao.getActiveListLocations()).thenReturn(listOf(curry36(), lostPlace, zukunft()))

        val result = resource.getActiveListLocations()
        val list: List<ListLocationDto> = result.entity as List<ListLocationDto>

        assertEquals(list.size,2)

        assertEquals(list[0].id, curry36().id)
        assertEquals(list[0].name, curry36().name)
        assertEquals(list[0].street, curry36().strasse)
        assertEquals(list[0].number, curry36().nr)
        assertEquals(list[0].latitude, curry36().laengengrad)
        assertEquals(list[0].longitude, curry36().breitengrad)

        assertEquals(list[1].id, zukunft().id)
        assertEquals(list[1].name, zukunft().name)
        assertEquals(list[1].street, zukunft().strasse)
        assertEquals(list[1].number, zukunft().nr)
        assertEquals(list[1].latitude, zukunft().laengengrad)
        assertEquals(list[1].longitude, zukunft().breitengrad)
    }

    @Test
    @Suppress("UNCHECKED_CAST")
    fun `getActiveListLocations returns empty list with empty list from database`() {
        whenever(dao.getActiveListLocations()).thenReturn(emptyList())

        val result = resource.getActiveListLocations()
        val list: List<ListLocationDto> = result.entity as List<ListLocationDto>

        assertEquals(list.size, 0)
    }

    @Test
    @Suppress("UNCHECKED_CAST")
    fun `getActiveListLocations returns empty list with null from database`() {
        whenever(dao.getActiveListLocations()).thenReturn(null)

        val result = resource.getActiveListLocations()
        val list: List<ListLocationDto> = result.entity as List<ListLocationDto>

        assertEquals(list.size, 0)
    }
}
