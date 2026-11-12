import wollok.game.*
import juego.direcciones.*
import juego.movimientos.*
import juego.semillas.*
import juego.partida.*
import juego.escalaTablero.*

object jardinero {
    var posicionLogica = game.origin()
    var posicionVisual = game.origin()
    var posicionDestino = game.origin()
    var direccion = abajo
    var semillaEnMano = sinSemilla
    var framesTranscurridos = 0

    // Cómo se está moviendo ahora: en el piso, en una escalera o deslizándose.
    // Es a este objeto al que le delega qué hacer con cada flecha.
    var estado = enElPiso

    const intervaloDeAnimacion = 16

    method position() = posicionVisual
    method image() = direccion.imagenJardinero()
    method direccion() = direccion
    method semillaEnMano() = semillaEnMano
    method estaDeslizando() = estado.estaDeslizando()
    method estaEnEscalera() = estado.estaEnEscalera()

    method empezarEn(posicionInicial) {
        posicionLogica = posicionInicial
        posicionVisual = posicionInicial
        posicionDestino = posicionInicial
        direccion = abajo
        semillaEnMano = sinSemilla
        estado = enElPiso
        framesTranscurridos = 0
    }

    // El jardinero no decide qué hacer con la flecha: se lo pregunta a su estado
    method mover(nuevaDireccion) {
        estado.mover(self, nuevaDireccion)
    }

    method empezarADeslizar(nuevaDireccion) {
        direccion = nuevaDireccion
        estado = deslizandose
        framesTranscurridos = 0
        game.onTick(intervaloDeAnimacion, "deslizar jardinero", { self.animarPaso() })
    }

    // Un escalón por vez, mientras siga habiendo escalera
    method subirUnEscalon(nuevaDireccion) {
        direccion = nuevaDireccion
        const siguiente = direccion.siguiente(posicionLogica)
        if (partida.puedeEntrarA(siguiente)) {
            // Deja la escalera en la que estaba. Si en la celda nueva hay otra, ella
            // misma vuelve a subirlo al procesar la llegada.
            estado = enElPiso
            posicionLogica = siguiente
            posicionVisual = siguiente
            self.procesarLlegada()
            // Si del otro lado ya no había escalera, se bajó: sigue de largo hasta
            // chocar, en vez de quedarse frenado en el aire.
            if (!self.estaEnEscalera() && partida.enJuego()) self.empezarADeslizar(direccion)
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
        if (self.estaDeslizando() && framesTranscurridos == 0) {
            posicionDestino = direccion.siguiente(posicionLogica)
            if (!partida.puedeEntrarA(posicionDestino)) self.frenar()
        }
        if (self.estaDeslizando()) {
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
        estado = enElPiso
        framesTranscurridos = 0
        posicionVisual = posicionLogica
        game.removeTickEvent("deslizar jardinero")
    }

    // Lo llama la escalera: lo frena y lo deja parado en ella hasta que el jugador decida
    method subirseAEscalera() {
        self.frenar()
        estado = enLaEscalera
    }

    // Lo llama el agujero de topo: sale por el otro extremo del túnel sin cortar el
    // movimiento, y sin volver a pisar lo que haya en la celda de salida.
    method caerEn(nuevaPosicion) {
        posicionLogica = nuevaPosicion
        posicionVisual = nuevaPosicion
        posicionDestino = nuevaPosicion
        framesTranscurridos = 0
    }

    // Lo llaman las espinas y el vidrio rajado. El culpable es el que sabe que cartel
    // de derrota mostrar, asi que se lo pasamos a la partida tal cual.
    method morir(culpable) {
        partida.perder(culpable)
    }

    method recoger(semilla) { semillaEnMano = semilla }

    method plantarEn(cruz) { semillaEnMano.aplicarEn(cruz) }

    // Lo llama la esquina, pasándole su diagonal: hacia dónde sale depende de por dónde
    // venía, así que es la diagonal la que resuelve el rebote.
    method desviarPor(diagonal) {
        direccion = diagonal.cambiar(direccion)
    }
}
