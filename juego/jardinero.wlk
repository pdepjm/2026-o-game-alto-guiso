import wollok.game.*
import juego.direcciones.*
import juego.semillas.*
import juego.partida.*
import juego.escalaTablero.*

object jardinero {
    var posicionLogica = game.origin()
    var posicionVisual = game.origin()
    var posicionDestino = game.origin()
    var direccion = abajo
    var semillaEnMano = sinSemilla
    var deslizando = false
    var framesTranscurridos = 0

    const intervaloDeAnimacion = 16

    method position() = posicionVisual
    method image() = direccion.imagenJardinero()
    method direccion() = direccion
    method semillaEnMano() = semillaEnMano
    method estaDeslizando() = deslizando

    method empezarEn(posicionInicial) {
        posicionLogica = posicionInicial
        posicionVisual = posicionInicial
        posicionDestino = posicionInicial
        direccion = abajo
        semillaEnMano = sinSemilla
        deslizando = false
        framesTranscurridos = 0
    }

    method mover(nuevaDireccion) {
        if (!deslizando) {
            direccion = nuevaDireccion
            deslizando = true
            framesTranscurridos = 0
            game.onTick(intervaloDeAnimacion, "deslizar jardinero", { self.animarPaso() })
        }
    }

    method avanzarUnPaso() {
        const siguiente = direccion.siguiente(posicionLogica)
        if (partida.puedeEntrarA(siguiente)) {
            posicionLogica = siguiente
            posicionVisual = siguiente
            framesTranscurridos = 0
            self.procesarLlegada()
        } else {
            self.frenar()
        }
    }

    method animarPaso() {
        if (deslizando && framesTranscurridos == 0) {
            posicionDestino = direccion.siguiente(posicionLogica)
            if (!partida.puedeEntrarA(posicionDestino)) self.frenar()
        }
        if (deslizando) {
            posicionVisual = direccion.siguienteSubcelda(posicionVisual)
            framesTranscurridos += 1
            if (framesTranscurridos == escalaTablero.factor()) {
                posicionLogica = posicionDestino
                posicionVisual = posicionLogica
                framesTranscurridos = 0
                self.procesarLlegada()
            }
        }
    }

    method procesarLlegada() {
        partida.elementosEn(posicionLogica).forEach({ elemento => elemento.pisadoPor(self) })
        partida.verificarSiTermino()
    }

    method frenar() {
        deslizando = false
        framesTranscurridos = 0
        posicionVisual = posicionLogica
        game.removeTickEvent("deslizar jardinero")
    }

    method recoger(semilla) { semillaEnMano = semilla }

    method plantarEn(cruz) { semillaEnMano.aplicarEn(cruz) }

    method girar(giro) {
        const giroElegido = giro.aplicar(direccion)
        direccion = if (partida.puedeEntrarA(giroElegido.siguiente(posicionLogica))) giroElegido else direccion.opuesta()
    }
}

object bolsaDeSemillas {
    method position() = escalaTablero.posicionCelda(1, escalaTablero.altoEnCeldas() - 1)
    method image() = jardinero.semillaEnMano().imagenDeBolsa()
}
