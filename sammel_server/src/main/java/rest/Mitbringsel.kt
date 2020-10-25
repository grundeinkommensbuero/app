package rest

class Mitbringsel {
    private var klemmbretter: Int = 0
    private var westen: Int = 0
    private var listen: Int = 0
    private var sonstiges: String = ""

    constructor()

    constructor(klemmbretter: Int?, westen: Int?, listen: Int?, sonstiges: String) {
        this.klemmbretter = klemmbretter ?: 0
        this.westen = westen ?: 0
        this.listen = listen ?: 0
        this.sonstiges = sonstiges
    ***REMOVED***
***REMOVED***
