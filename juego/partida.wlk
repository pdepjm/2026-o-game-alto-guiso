import wollok.game.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*
import juego.jardinero.*
import juego.semillas.*
import juego.cruces.*
import niveles.mapa1.*
import juego.bloques.*
import juego.direcciones.*
import juego.escalaTablero.*

object partida {
    var nivel = mapa1
    var ganado = false

    // Todo lo que está puesto en el tablero: vallas, semillas, cruces, piedras y charcos.
    // Es una sola lista para que el jardinero le pueda preguntar a cualquiera y para que
    // al cambiar de nivel se saquen todos de la pantalla.
    const elementosDelNivel = []

    // Las cruces del nivel, para saber cuándo está todo plantado. Son las mismas que
    // están en elementosDelNivel, solo que acá las tenemos a mano.
    const cruces = []

    const semillas = [semillaRoja, semillaAzul, semillaAmarilla]

    method nivel() = nivel
    method nivel(unNivel) { nivel = unNivel }
    method ganado() = ganado
    method cruces() = cruces
    method elementos() = elementosDelNivel

    // ----- Armado del nivel -----

    method armar() {
        elementosDelNivel.clear()
        cruces.clear()
        ganado = false
        const filas = nivel.mapa()
        const alto = filas.size()
        const ancho = filas.first().size()
        const origenX = (escalaTablero.anchoEnCeldas() - ancho).div(2) * escalaTablero.factor()
        const origenY = (escalaTablero.altoEnCeldas() - alto).div(2) * escalaTablero.factor()
        (0 .. alto - 1).forEach({ fila =>
            (0 .. ancho - 1).forEach({ columna =>
                const posicion = game.at(
                    origenX + columna * escalaTablero.factor(),
                    origenY + (alto - 1 - fila) * escalaTablero.factor()
                )
                self.ubicar(filas.get(fila).charAt(columna), posicion)
            })
        })
    }

    method ubicar(letra, posicion) {
        if (letra == "#") self.agregar(new Valla(position = posicion))
        if (letra == "P") self.agregar(new Piedra(position = posicion))
        if (letra == "B") self.agregar(new CharcoDeBarro(position = posicion))
        if (letra == "D") self.agregar(new Esquina(position = posicion, giro = giroDerecha))
        if (letra == "I") self.agregar(new Esquina(position = posicion, giro = giroIzquierda))
        if (letra == "T") self.agregar(new Esquina(position = posicion, giro = giroIzquierdaSuperiorDerecha))
        if (letra == "O") self.agregar(new Esquina(position = posicion, giro = giroIzquierdaInferiorDerecha))
        if (letra == "J") jardinero.empezarEn(posicion)
        semillas.filter({ semilla => semilla.letra() == letra }).forEach({ semilla => self.ponerSemilla(semilla, posicion) })
        semillas.filter({ semilla => semilla.letraCruz() == letra }).forEach({ semilla => self.ponerCruz(semilla, posicion) })
    }

    method agregar(elemento) { elementosDelNivel.add(elemento) }

    method ponerSemilla(semilla, posicion) {
        semilla.position(posicion)
        self.agregar(semilla)
    }

    method ponerCruz(semillaEsperada, posicion) {
        const nuevaCruz = new Cruz(position = posicion, semilla = semillaEsperada)
        cruces.add(nuevaCruz)
        self.agregar(nuevaCruz)
    }

    // ----- Reglas del tablero (las consulta el jardinero) -----

    // Cada elemento decide si se lo puede atravesar: las vallas y las piedras no, el resto sí
    method puedeEntrarA(posicion) = self.elementosEn(posicion).all({ elemento => elemento.esTraspasable() })

    method elementosEn(posicion) = elementosDelNivel.filter({ elemento => elemento.position() == posicion })

    method todoPlantado() = cruces.all({ cruz => cruz.florecida() })

    method verificarSiTermino() {
        if (!ganado && self.todoPlantado()) self.ganar()
    }

    method ganar() {
        ganado = true
        jardinero.frenar()
        game.say(jardinero, "¡Jardín completo! V para volver")
    }

    // ----- Pantalla -----

    method mostrar() {
        self.armar()
        elementosDelNivel.forEach({ elemento => game.addVisual(elemento) })
        game.addVisual(jardinero) // último, para que se dibuje arriba de todo
        game.addVisual(bolsaDeSemillas)
    }

    method ocultar() {
        jardinero.frenar()
        elementosDelNivel.forEach({ elemento => game.removeVisual(elemento) })
        game.removeVisual(jardinero)
        game.removeVisual(bolsaDeSemillas)
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
