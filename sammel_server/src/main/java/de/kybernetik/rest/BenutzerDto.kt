package de.kybernetik.rest

import de.kybernetik.database.benutzer.Benutzer

// NUR FÜR REGISTRIERUNG/AUTHENTIFIZIERUNG BENUTZEN!
data class Login(
        var secret: String? = null,
        var firebaseKey: String? = null,
        var user: BenutzerDto = BenutzerDto()) {
}

data class BenutzerDto(
        var id: Long? = 0,
        var name: String? = null,
        var color: Long? = null) {

    fun convertToBenutzer(): Benutzer {
        return Benutzer(id ?: 0, name, color)
    }

    companion object {
        fun convertFromBenutzer(benutzer: Benutzer): BenutzerDto {
            return BenutzerDto(benutzer.id, benutzer.name, benutzer.color)
        }
    }
}
