package rest

import database.benutzer.Benutzer

// NUR FÜR REGISTRIERUNG/AUTHENTIFIZIERUNG BENUTZEN!
data class Login(
        var secret: String? = null,
        var firebaseKey: String? = null,
        var user: BenutzerDto = BenutzerDto()) {
***REMOVED***

data class BenutzerDto(
        var id: Long? = 0,
        var name: String? = null,
        var color: Long? = null) {

    fun convertToBenutzer(): Benutzer {
        return Benutzer(id ?: 0, name, color)
    ***REMOVED***

    companion object {
        fun convertFromBenutzer(benutzer: Benutzer): BenutzerDto {
            return BenutzerDto(benutzer.id, benutzer.name, benutzer.color)
        ***REMOVED***
    ***REMOVED***
***REMOVED***
