package de.kybernetik.shared

import java.lang.Exception

class FehlenderWertException(wert: String) : Exception("Fehlender Wert für $wert")
