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
    // Mientras está parado en una escalera sube y baja de a un escalón, en vez de deslizarse
    var enEscalera = false

    const intervaloDeAnimacion = 16

    method position() = posicionVisual
    method image() = direccion.imagenJardinero()
    method direccion() = direccion
    method semillaEnMano() = semillaEnMano
    method estaDeslizando() = deslizando
    method estaEnEscalera() = enEscalera

    method empezarEn(posicionInicial) {
        posicionLogica = posicionInicial
        posicionVisual = posicionInicial
        posicionDestino = posicionInicial
        direccion = abajo
        semillaEnMano = sinSemilla
        deslizando = false
        enEscalera = false
        framesTranscurridos = 0
    }

    method mover(nuevaDireccion) {
        if (!deslizando) {
            direccion = nuevaDireccion
            // En la escalera se sube y se baja de a un escalón; para los costados se baja
            // de la escalera y vuelve a deslizarse hasta chocar, como siempre.
            if (enEscalera && nuevaDireccion.esVertical()) self.subirUnEscalon()
            else self.empezarADeslizar()
        }
    }

    method empezarADeslizar() {
        deslizando = true
        framesTranscurridos = 0
        game.onTick(intervaloDeAnimacion, "deslizar jardinero", { self.animarPaso() })
    }

    method subirUnEscalon() {
        const siguiente = direccion.siguiente(posicionLogica)
        if (partida.puedeEntrarA(siguiente)) {
            posicionLogica = siguiente
            posicionVisual = siguiente
            self.procesarLlegada()
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
        // Se baja de la escalera al llegar a una celda nueva; si en esa celda hay otra
        // escalera, ella misma se encarga de volver a subirlo.
        enEscalera = false
        partida.elementosEn(posicionLogica).forEach({ elemento => elemento.pisadoPor(self) })
        partida.verificarSiTermino()
    }

    method frenar() {
        deslizando = false
        framesTranscurridos = 0
        posicionVisual = posicionLogica
        game.removeTickEvent("deslizar jardinero")
    }

    // Lo llama la escalera: se queda parado en ella hasta que el jugador decida
    method subirseAEscalera() {
        enEscalera = true
        self.frenar()
    }

    // Lo llama el agujero de topo: sale por el otro extremo del túnel sin cortar el
    // movimiento, y sin volver a pisar lo que haya en la celda de salida.
    method caerEn(nuevaPosicion) {
        posicionLogica = nuevaPosicion
        posicionVisual = nuevaPosicion
        posicionDestino = nuevaPosicion
        framesTranscurridos = 0
    }

    // Lo llaman las espinas
    method pincharse() {
        partida.perder()
    }

    method recoger(semilla) { semillaEnMano = semilla }

    method plantarEn(cruz) { semillaEnMano.aplicarEn(cruz) }

    method girar(giro) {
        const giroElegido = giro.aplicar(direccion)
        direccion = if (partida.puedeEntrarA(giroElegido.siguiente(posicionLogica))) giroElegido else direccion.opuesta()
    }
}
