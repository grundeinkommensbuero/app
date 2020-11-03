package de.kybernetik.shared

import org.junit.Test

import org.junit.Assert.*
import de.kybernetik.rest.RestFehlermeldung
import javax.ejb.EJBAccessException
import javax.ejb.EJBException

class EjbAccessExceptionMapperTest {

    @Test
    fun `toResponse behandelt Rechte-Fehler`() {
        val ejbAccessExceptionMapper = EjbAccessExceptionMapper()

        val response = ejbAccessExceptionMapper.toResponse(EJBAccessException())

        assertEquals(response.status, 403)
        assertTrue(response.entity is RestFehlermeldung)
        assertEquals((response.entity as RestFehlermeldung).meldung,
                "Du hast nicht die notwendigen Rechte um diese Funktion auszuführen")
    ***REMOVED***

    @Test
    fun `toResponse behandelt Server-Fehler`() {
        val ejbAccessExceptionMapper = EjbAccessExceptionMapper()

        val response = ejbAccessExceptionMapper.toResponse(EJBException("Nachricht"))

        assertEquals(response.status, 500)
        assertTrue(response.entity is RestFehlermeldung)
        assertTrue((response.entity as RestFehlermeldung).meldung!!.contains("Nachricht"))
    ***REMOVED***
***REMOVED***