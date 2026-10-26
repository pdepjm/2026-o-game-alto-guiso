import wollok.game.*

object sonidos {
    const ambiente = game.sound("sonido/carlos-cdg05-sonido-de-parque-con-pajaros-291538.mp3")
    const sonidoDeTecla = "sonido/dragon-studio-mouse-click-free-444807.mp3"
    const sonidoDeHielo = "sonido/spinopel-thin-ice-crunches-456391.mp3"
    var volumenGeneral = 1.0
    var volumenAmbiente = 0.25
    var generalSilenciado = false
    var ambienteSilenciado = false

    method volumenGeneral() = volumenGeneral
    method volumenAmbiente() = volumenAmbiente
    method estaSilenciadoGeneral() = generalSilenciado
    method estaSilenciadoAmbiente() = ambienteSilenciado

    method iniciar() {
        ambiente.shouldLoop(true)
        self.actualizarVolumenAmbiente()
        ambiente.play()
    }

    method reproducirSonidoDeTecla() {
        self.reproducirEfecto(sonidoDeTecla)
    }

    method reproducirSonidoDeHielo() {
        self.reproducirEfecto(sonidoDeHielo)
    }

    method reproducirEfecto(ruta) {
        const sonido = game.sound(ruta)
        sonido.volume(self.volumenEfectos())
        sonido.play()
    }

    method bajarVolumenGeneral() {
        if (volumenGeneral >= 0.1) volumenGeneral = volumenGeneral - 0.1
        self.actualizarVolumenAmbiente()
    }

    method subirVolumenGeneral() {
        if (volumenGeneral <= 0.9) volumenGeneral = volumenGeneral + 0.1
        self.actualizarVolumenAmbiente()
    }

    method bajarVolumenAmbiente() {
        if (volumenAmbiente >= 0.1) volumenAmbiente = volumenAmbiente - 0.1
        else volumenAmbiente = 0
        self.actualizarVolumenAmbiente()
    }

    method subirVolumenAmbiente() {
        if (volumenAmbiente <= 0.9) volumenAmbiente = volumenAmbiente + 0.1
        else volumenAmbiente = 1
        self.actualizarVolumenAmbiente()
    }

    method alternarSilencioGeneral() {
        generalSilenciado = !generalSilenciado
        self.actualizarVolumenAmbiente()
    }

    method alternarSilencioAmbiente() {
        ambienteSilenciado = !ambienteSilenciado
        self.actualizarVolumenAmbiente()
    }

    method volumenEfectos() = if (generalSilenciado) 0 else volumenGeneral

    method volumenAmbienteEfectivo() =
        if (generalSilenciado || ambienteSilenciado) 0
        else volumenGeneral * volumenAmbiente

    method actualizarVolumenAmbiente() {
        ambiente.volume(self.volumenAmbienteEfectivo())
    }

    method restablecerConfiguracion() {
        volumenGeneral = 1.0
        volumenAmbiente = 0.25
        generalSilenciado = false
        ambienteSilenciado = false
        self.actualizarVolumenAmbiente()
    }
}
