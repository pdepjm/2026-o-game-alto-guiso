import wollok.game.*

object sonidos {
    const ambiente = game.sound("sonido/carlos-cdg05-sonido-de-parque-con-pajaros-291538.mp3")
    const sonidoDeTecla = "sonido/dragon-studio-mouse-click-free-444807.mp3"
    const sonidoDeHielo = "sonido/spinopel-thin-ice-crunches-456391.mp3"
    // Los efectos que ya sonaron. Wollok Game mete cada sonido reproducido dentro de
    // game.sounds y solo lo saca `stop()`, y el motor serializa esa lista ENTERA al
    // navegador en cada frame. Si no los soltamos, cada tecla apretada deja basura que
    // se manda por el resto de la partida y el juego se va poniendo cada vez mas lento.
    const efectosReproducidos = []

    // Cuantos dejamos vivos. Los efectos duran menos de un segundo, asi que para cuando
    // suenan los siguientes el mas viejo ya termino y soltarlo no se escucha.
    const efectosVivos = 5

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
        self.soltarElEfectoMasViejo()
        const sonido = game.sound(ruta)
        sonido.volume(self.volumenEfectos())
        sonido.play()
        efectosReproducidos.add(sonido)
    }

    // Libera el efecto mas viejo cuando ya hay demasiados dando vueltas
    method soltarElEfectoMasViejo() {
        if (efectosReproducidos.size() >= efectosVivos) {
            const masViejo = efectosReproducidos.first()
            efectosReproducidos.remove(masViejo)
            masViejo.stop()
        }
    }

    method efectosReproducidos() = efectosReproducidos

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
