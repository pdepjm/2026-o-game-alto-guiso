import wollok.game.*
import juego.direcciones.*
import juego.semillas.*
import juego.partida.*

object jardinero {
    var property position = game.origin()
    var direccion = abajo
    var semillaEnMano = sinSemilla
    var deslizando = false

    method image() = direccion.imagenJardinero()
    method semillaEnMano() = semillaEnMano
    method estaDeslizando() = deslizando

    method empezarEn(posicionInicial) {
        position = posicionInicial
        direccion = abajo
        semillaEnMano = sinSemilla
        deslizando = false
    }

    method mover(nuevaDireccion) {
        if (!deslizando) {
            direccion = nuevaDireccion
            deslizando = true
            game.onTick(60, "deslizar jardinero", { self.avanzarUnPaso() })
        }
    }

    method avanzarUnPaso() {
        const siguiente = direccion.siguiente(position)
        if (partida.puedeEntrarA(siguiente)) {
            position = siguiente
            partida.elementosEn(position).forEach({ elemento => elemento.pisadoPor(self) })
            partida.verificarSiTermino()
        } else {
            self.frenar()
        }
    }

    method frenar() {
        deslizando = false
        game.removeTickEvent("deslizar jardinero")
    }

    method recoger(semilla) { semillaEnMano = semilla }

    method plantarEn(cruz) { semillaEnMano.aplicarEn(cruz) }
}
