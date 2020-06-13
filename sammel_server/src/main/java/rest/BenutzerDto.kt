package rest

import database.benutzer.Benutzer

// NUR FÜR REGISTRIERUNG/AUTHENTIFIZIERUNG BENUTZEN!
data class Login(
        var secret: String = "",
        var firebaseKey: String = "",
        var benutzer: BenutzerDto = BenutzerDto()) {
}

data class BenutzerDto(
        var id: Long? = 0,
        var name: String? = "") {

    fun convertToBenutzer(): Benutzer {
        return Benutzer(id ?: 0, name ?: "")
    }

    companion object {
        fun convertFromBenutzer(benutzer: Benutzer): BenutzerDto {
            return BenutzerDto(benutzer.id, benutzer.name)
        }
    }
}
