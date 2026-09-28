import wollok.game.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*
import juego.jardinero.*
import juego.semillas.*
import juego.cruces.*
import niveles.mapa1.*
import juego.cercas.*

object partida {
    var nivel = mapa1
    var ganado = false
    const cercas = #{}
    const semillasEnJuego = []
    const cruces = []
    const vallasEnJuego = []
    const semillas = [semillaRoja, semillaAzul, semillaAmarilla]
    const crucesDisponibles = [cruz1, cruz2, cruz3, cruz4, cruz5, cruz6]

    method nivel() = nivel
    method nivel(unNivel) { nivel = unNivel }
    method ganado() = ganado
    method cruces() = cruces

    method armar() {
        cercas.clear()
        semillasEnJuego.clear()
        cruces.clear()
        vallasEnJuego.clear()
        ganado = false
        const filas = nivel.mapa()
        const alto = filas.size()
        const ancho = filas.first().size()
        const origenX = (game.width() - ancho).div(2)
        const origenY = (game.height() - alto).div(2)
        (0 .. alto - 1).forEach({ fila =>
            (0 .. ancho - 1).forEach({ columna =>
                const posicion = game.at(origenX + columna, origenY + alto - 1 - fila)
                self.ubicar(filas.get(fila).charAt(columna), posicion)
            })
        })
    }

    method ubicar(letra, posicion) {
        if (letra == "#") self.ponerValla(posicion)
        if (letra == "J") jardinero.empezarEn(posicion)
        semillas.filter({ semilla => semilla.letra() == letra }).forEach({ semilla => self.ponerSemilla(semilla, posicion) })
        semillas.filter({ semilla => semilla.letraCruz() == letra }).forEach({ semilla => self.ponerCruz(semilla, posicion) })
    }

    method ponerSemilla(semilla, posicion) {
        semilla.position(posicion)
        semillasEnJuego.add(semilla)
    }

    method ponerValla(posicion) {
        cercas.add(posicion)
        const nuevaValla = new Valla(position = posicion)
        vallasEnJuego.add(nuevaValla)
    }

    method ponerCruz(semilla, posicion) {
        const cruz = crucesDisponibles.get(cruces.size())
        cruz.position(posicion)
        cruz.semilla(semilla)
        cruz.florecida(false)
        cruces.add(cruz)
    }

    method puedeEntrarA(posicion) = !cercas.contains(posicion)

    method elementos() = semillasEnJuego + cruces

    method elementosEn(posicion) = self.elementos().filter({ elemento => elemento.position() == posicion })

    method todoPlantado() = cruces.all({ cruz => cruz.florecida() })

    method verificarSiTermino() {
        if (!ganado && self.todoPlantado()) self.ganar()
    }

    method ganar() {
        ganado = true
        jardinero.frenar()
        game.say(jardinero, "¡Jardín completo! V para volver")
    }

    method mostrar() {
        self.armar()
        vallasEnJuego.forEach({ valla => game.addVisual(valla) })
        self.elementos().forEach({ elemento => game.addVisual(elemento) })
        game.addVisual(jardinero)
    }

    method ocultar() {
        jardinero.frenar()
        vallasEnJuego.forEach({ valla => game.removeVisual(valla) })
        self.elementos().forEach({ elemento => game.removeVisual(elemento) })
        game.removeVisual(jardinero)
    }

    method presionarDireccion(direccion) {
        if (!ganado) jardinero.mover(direccion)
    }

    method presionarReiniciar() {
        self.ocultar()
        self.mostrar()
    }

    method presionarVolver() { navegador.irA(selectorDeNiveles) }
    method presionarJugar() {}
    method presionarNivel(numero) {}
}
