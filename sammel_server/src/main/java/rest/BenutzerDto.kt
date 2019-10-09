package rest

import database.benutzer.Benutzer

// NUR FÜR REGISTRIERUNG BENUTZEN AN LESENDER SCHNITTSSTELLE!
data class Login(
        var passwortHash: String = "",
        var benutzer: BenutzerDto = BenutzerDto()){
}

data class BenutzerDto(
        var id: Long? = 0,
        var name: String? = "",
        var telefonnummer: String? = null) {

    fun convertToBenutzer(passwortHash: String = ""): Benutzer {
        return Benutzer(id ?: 0, name ?: "", passwortHash, telefonnummer)
    }

    companion object {
        fun convertFromBenutzer(benutzer: Benutzer): BenutzerDto {
            return BenutzerDto(benutzer.id, benutzer.name, benutzer.telefonnummer)
        }
    }
}
