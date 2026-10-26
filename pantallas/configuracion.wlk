import wollok.game.*
import pantallas.navegador.*
import pantallas.menuPrincipal.*
import pantallas.boton.*
import pantallas.fondoMenu.*
import utils.manager.*
import utils.sonidos.*

object panelDeControlesDeAudio {
    method position() = game.at(12, 17)
    method image() = assetsManager.controlesDeAudio()
}

class SegmentoVolumen {
    const property canal
    const property indice
    const property position

    method image() =
        if (self.estaActivo()) assetsManager.volumenActivo()
        else assetsManager.volumenInactivo()

    method estaActivo() =
        if (canal == "general") indice <= sonidos.volumenGeneral() * 10
        else indice <= sonidos.volumenAmbiente() * 10
}

class IndicadorDeSilencio {
    const property canal
    const property position

    method image() =
        if (self.estaSilenciado()) assetsManager.audioSilenciado()
        else assetsManager.audioActivo()

    method estaSilenciado() =
        if (canal == "general") sonidos.estaSilenciadoGeneral()
        else sonidos.estaSilenciadoAmbiente()
}

object configuracion {
    const botonVolver = new Boton(position = game.at(2, 42), image = assetsManager.botonVolver())
    const segmentosGenerales = (1..10).map({ indice =>
        new SegmentoVolumen(
            canal = "general",
            indice = indice,
            position = game.at(40 + (indice - 1) * 2, 24)
        )
    })
    const segmentosAmbiente = (1..10).map({ indice =>
        new SegmentoVolumen(
            canal = "ambiente",
            indice = indice,
            position = game.at(40 + (indice - 1) * 2, 19.5)
        )
    })
    const silencioGeneral = new IndicadorDeSilencio(canal = "general", position = game.at(62, 24))
    const silencioAmbiente = new IndicadorDeSilencio(canal = "ambiente", position = game.at(62, 19.5))

    method imagenDeTeclas() = assetsManager.teclasDeConfiguracion()

    method mostrar() {
        game.addVisual(fondoMenu)
        game.addVisual(botonVolver)
        game.addVisual(panelDeControlesDeAudio)
        segmentosGenerales.forEach({ segmento => game.addVisual(segmento) })
        segmentosAmbiente.forEach({ segmento => game.addVisual(segmento) })
        game.addVisual(silencioGeneral)
        game.addVisual(silencioAmbiente)
    }

    method ocultar() {
        game.removeVisual(fondoMenu)
        game.removeVisual(botonVolver)
        game.removeVisual(panelDeControlesDeAudio)
        segmentosGenerales.forEach({ segmento => game.removeVisual(segmento) })
        segmentosAmbiente.forEach({ segmento => game.removeVisual(segmento) })
        game.removeVisual(silencioGeneral)
        game.removeVisual(silencioAmbiente)
    }

    method presionarVolver() { navegador.irA(menuPrincipal) }
    method presionarJugar() { sonidos.bajarVolumenGeneral() }
    method presionarConfiguracion() { sonidos.subirVolumenGeneral() }
    method presionarNivel(numero) {
        if (numero == 1) sonidos.alternarSilencioGeneral()
        if (numero == 2) sonidos.alternarSilencioAmbiente()
    }
    method presionarDireccion(direccion) {}
    method presionarReiniciar() { sonidos.bajarVolumenAmbiente() }
    method presionarSiguiente() { sonidos.subirVolumenAmbiente() }
}
