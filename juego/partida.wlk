import wollok.game.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*
import pantallas.hud.*
import juego.jardinero.*
import juego.manoDelJardinero.*
import juego.semillas.*
import juego.cruces.*
import niveles.mapa1.*
import juego.bloques.*
import juego.direcciones.*
import juego.escalaTablero.*
import utils.manager.*

object partida {
    var nivel = mapa1
    var ganado = false
    var perdido = false

    // Todo lo que está puesto en el tablero: vallas, semillas, cruces, piedras y charcos.
    // Es una sola lista para que el jardinero le pueda preguntar a cualquiera y para que
    // al cambiar de nivel se saquen todos de la pantalla.
    const elementosDelNivel = []

    // Las cruces del nivel, para saber cuándo está todo plantado. Son las mismas que
    // están en elementosDelNivel, solo que acá las tenemos a mano.
    const cruces = []

    const semillas = [semillaRoja, semillaAzul, semillaAmarilla]

    // Los agujeros de topo se emparejan de a dos en el orden en que aparecen en el mapa.
    // Acá queda el que todavía está esperando su pareja (ninguno o uno).
    const agujerosSinPareja = []

    method nivel() = nivel
    method nivel(unNivel) { nivel = unNivel }
    method ganado() = ganado
    method perdido() = perdido
    method cruces() = cruces
    method elementos() = elementosDelNivel

    // Lo llama el selector al elegir un nivel desbloqueado
    method jugar(unNivel) {
        nivel = unNivel
        navegador.irA(self)
    }

    method imagenDeTeclas() = assetsManager.teclasDeLaPartida()

    // ----- Armado del nivel -----

    method armar() {
        elementosDelNivel.clear()
        cruces.clear()
        agujerosSinPareja.clear()
        ganado = false
        perdido = false
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
        if (letra == "X") self.agregar(new Espinas(position = posicion))
        if (letra == "E") self.agregar(new Escalera(position = posicion))
        if (letra == "H") self.ponerAgujero(posicion)
        if (letra == "D") self.agregar(new Esquina(position = posicion, giro = giroDerecha))
        if (letra == "I") self.agregar(new Esquina(position = posicion, giro = giroIzquierda))
        if (letra == "T") self.agregar(new Esquina(position = posicion, giro = giroIzquierdaSuperiorDerecha))
        if (letra == "O") self.agregar(new Esquina(position = posicion, giro = giroIzquierdaInferiorDerecha))
        if (letra == "J") jardinero.empezarEn(posicion)
        semillas.filter({ semilla => semilla.letra() == letra }).forEach({ semilla => self.ponerSemilla(semilla, posicion) })
        semillas.filter({ semilla => semilla.letraCruz() == letra }).forEach({ semilla => self.ponerCruz(semilla, posicion) })
    }

    method agregar(elemento) { elementosDelNivel.add(elemento) }

    method ponerAgujero(posicion) {
        const nuevo = new Agujero(position = posicion)
        // Si había uno esperando, se emparejan entre ellos y la lista queda vacía otra vez
        agujerosSinPareja.forEach({ anterior =>
            anterior.emparejarCon(nuevo)
            nuevo.emparejarCon(anterior)
        })
        if (agujerosSinPareja.isEmpty()) agujerosSinPareja.add(nuevo) else agujerosSinPareja.clear()
        self.agregar(nuevo)
    }

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
        cronometro.parar()
        selectorDeNiveles.desbloquearSiguienteA(nivel)
        self.mostrarCartel()
    }

    method mostrarCartel() {
        cartelDeVictoria.mostrar(self.nota())
    }

    // Lo llama el jardinero cuando se clava con las espinas
    method perder() {
        perdido = true
        jardinero.frenar()
        cronometro.parar()
        cartelDeDerrota.mostrar()
    }

    method nota() = nivel.notaPara(cronometro.segundos())

    // ----- Pantalla -----

    method mostrar() {
        self.armar()
        elementosDelNivel.forEach({ elemento => game.addVisual(elemento) })
        game.addVisual(jardinero) // el jardinero y su mano, al final, para que queden arriba
        game.addVisual(manoDelJardinero)
        relojDePantalla.mostrar()
        cronometro.arrancar()
    }

    method ocultar() {
        jardinero.frenar()
        cronometro.parar()
        elementosDelNivel.forEach({ elemento => game.removeVisual(elemento) })
        game.removeVisual(jardinero)
        game.removeVisual(manoDelJardinero)
        relojDePantalla.ocultar()
        cartelDeVictoria.ocultar()
        cartelDeDerrota.ocultar()
    }

    method presionarDireccion(direccion) {
        if (!ganado && !perdido) jardinero.mover(direccion)
    }

    method presionarReiniciar() {
        self.ocultar()
        self.mostrar()
    }

    method presionarVolver() { navegador.irA(selectorDeNiveles) }
    method presionarJugar() {}
    method presionarNivel(numero) {}
}
