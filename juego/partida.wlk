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


// En qué está la partida. Antes esto eran dos booleanos, `ganado` y `perdido`, para tres
// situaciones que no pueden darse a la vez, y había que combinarlos con ifs en cada lugar
// donde importaban. Ahora hay un objeto por situación y la partida le delega lo que cambia:
// qué teclas se muestran, si las flechas mueven al jardinero y si todavía se puede ganar
// o perder.

object jugando {
    method ganado() = false
    method perdido() = false
    method enJuego() = true

    method imagenDeTeclas(partida) = assetsManager.teclasDeLaPartida()

    method presionarDireccion(partida, direccion) { jardinero.mover(direccion) }

    method verificarSiTermino(partida) {
        if (partida.todoPlantado()) partida.terminarGanando()
    }

    method perder(partida, culpable) { partida.terminarPerdiendo(culpable) }

    method presionarSiguiente(partida) {}
}

object ganada {
    method ganado() = true
    method perdido() = false
    method enJuego() = false

    method imagenDeTeclas(partida) =
        if (partida.hayNivelSiguiente()) assetsManager.teclasDeVictoria()
        else assetsManager.teclasDeVictoriaFinal()

    // Ya terminó: ni las flechas mueven, ni se puede volver a ganar o perder
    method presionarDireccion(partida, direccion) {}
    method verificarSiTermino(partida) {}
    method perder(partida, culpable) {}

    method presionarSiguiente(partida) { partida.irAlNivelSiguiente() }
}

object perdida {
    method ganado() = false
    method perdido() = true
    method enJuego() = false

    // Las mismas teclas que jugando, porque lo que sirve es R para reintentar y V para volver
    method imagenDeTeclas(partida) = assetsManager.teclasDeLaPartida()

    method presionarDireccion(partida, direccion) {}
    method verificarSiTermino(partida) {}
    method perder(partida, culpable) {}
    method presionarSiguiente(partida) {}
}

object ubicadorVacio {
    method ubicar(partida, posicion) {}
}

object ubicadorDeValla {
    method ubicar(partida, posicion) { partida.agregar(new Valla(position = posicion)) }
}

object ubicadorDePiedra {
    method ubicar(partida, posicion) { partida.agregar(new Piedra(position = posicion)) }
}

object ubicadorDeBarro {
    method ubicar(partida, posicion) { partida.agregar(new CharcoDeBarro(position = posicion)) }
}

object ubicadorDeEspinas {
    method ubicar(partida, posicion) { partida.agregar(new Espinas(position = posicion)) }
}

object ubicadorDeEscalera {
    method ubicar(partida, posicion) { partida.agregar(new Escalera(position = posicion)) }
}

object ubicadorDeVidrio {
    method ubicar(partida, posicion) { partida.agregar(new Vidrio(position = posicion)) }
}

object ubicadorDeAgujero {
    method ubicar(partida, posicion) { partida.ponerAgujero(posicion) }
}

object ubicadorDeJardinero {
    method ubicar(partida, posicion) { jardinero.empezarEn(posicion) }
}

object ubicadorDeSemillaRoja {
    method ubicar(partida, posicion) { partida.ponerSemilla(semillaRoja, posicion) }
}

object ubicadorDeSemillaAzul {
    method ubicar(partida, posicion) { partida.ponerSemilla(semillaAzul, posicion) }
}

object ubicadorDeSemillaAmarilla {
    method ubicar(partida, posicion) { partida.ponerSemilla(semillaAmarilla, posicion) }
}

class UbicadorDeEsquina {
    const property diagonal
    const property image

    method ubicar(partida, posicion) {
        partida.agregar(new Esquina(position = posicion, diagonal = diagonal, image = image))
    }
}

class UbicadorDeCruz {
    const property semilla

    method ubicar(partida, posicion) { partida.ponerCruz(semilla, posicion) }
}

object partida {
    var nivel = mapa1
    // En qué está: jugando, ganada o perdida. A él le delega lo que cambia según eso.
    var estado = jugando

    // Todo lo que está puesto en el tablero: vallas, semillas, cruces, piedras y charcos.
    // Es una sola lista para que el jardinero le pueda preguntar a cualquiera y para que
    // al cambiar de nivel se saquen todos de la pantalla.
    const elementosDelNivel = []

    // Las cruces del nivel, para saber cuándo está todo plantado. Son las mismas que
    // están en elementosDelNivel, solo que acá las tenemos a mano.
    const cruces = []

    // Índice por posición para evitar recorrer todos los elementos en cada movimiento.
    var elementosPorPosicion = new Dictionary()
    var ubicadoresMapa = new Dictionary()

    // Los agujeros de topo se emparejan de a dos en el orden en que aparecen en el mapa.
    // Acá queda el que todavía está esperando su pareja (ninguno o uno).
    const agujerosSinPareja = []

    method nivel() = nivel
    method nivel(unNivel) { nivel = unNivel }
    method ganado() = estado.ganado()
    method perdido() = estado.perdido()
    method enJuego() = estado.enJuego()
    method cruces() = cruces
    method elementos() = elementosDelNivel

    // Lo llama el selector al elegir un nivel desbloqueado
    method jugar(unNivel) {
        nivel = unNivel
        navegador.irA(self)
    }

    method imagenDeTeclas() = estado.imagenDeTeclas(self)

    method hayNivelSiguiente() =
        selectorDeNiveles.niveles().any({ otro => otro.numero() == nivel.numero() + 1 })

    // ----- Armado del nivel -----

    method armar() {
        elementosDelNivel.clear()
        elementosPorPosicion = new Dictionary()
        cruces.clear()
        agujerosSinPareja.clear()
        estado = jugando
        self.configurarUbicadoresMapa()
        
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

    method configurarUbicadoresMapa() {
        ubicadoresMapa = new Dictionary()
        ubicadoresMapa.put("#", ubicadorDeValla)
        ubicadoresMapa.put("P", ubicadorDePiedra)
        ubicadoresMapa.put("B", ubicadorDeBarro)
        ubicadoresMapa.put("X", ubicadorDeEspinas)
        ubicadoresMapa.put("E", ubicadorDeEscalera)
        ubicadoresMapa.put("V", ubicadorDeVidrio)
        ubicadoresMapa.put("H", ubicadorDeAgujero)
        ubicadoresMapa.put("I", new UbicadorDeEsquina(diagonal = diagonalCreciente, image = assetsManager.rampaArribaIzquierda()))
        ubicadoresMapa.put("O", new UbicadorDeEsquina(diagonal = diagonalCreciente, image = assetsManager.rampaAbajoDerecha()))
        ubicadoresMapa.put("D", new UbicadorDeEsquina(diagonal = diagonalDecreciente, image = assetsManager.rampaArribaDerecha()))
        ubicadoresMapa.put("T", new UbicadorDeEsquina(diagonal = diagonalDecreciente, image = assetsManager.rampaAbajoIzquierda()))
        ubicadoresMapa.put("J", ubicadorDeJardinero)
        ubicadoresMapa.put("R", ubicadorDeSemillaRoja)
        ubicadoresMapa.put("A", ubicadorDeSemillaAzul)
        ubicadoresMapa.put("M", ubicadorDeSemillaAmarilla)
        ubicadoresMapa.put("r", new UbicadorDeCruz(semilla = semillaRoja))
        ubicadoresMapa.put("a", new UbicadorDeCruz(semilla = semillaAzul))
        ubicadoresMapa.put("m", new UbicadorDeCruz(semilla = semillaAmarilla))
    }

    method ubicar(letra, posicion) {
        ubicadoresMapa.getOrElse(letra, { => ubicadorVacio }).ubicar(self, posicion)
    }

    method agregar(elemento) {
        elementosDelNivel.add(elemento)
        const clave = elemento.position().toString()
        const elementosEnPosicion = elementosPorPosicion.getOrElse(clave, { => [] })
        elementosEnPosicion.add(elemento)
        elementosPorPosicion.put(clave, elementosEnPosicion)
    }

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

    method elementosEn(posicion) = elementosPorPosicion.getOrElse(posicion.toString(), { => [] })

    method todoPlantado() = cruces.all({ cruz => cruz.florecida() })

    // Lo pregunta el jardinero en cada celda. Si ya terminó, el estado no hace nada.
    method verificarSiTermino() { estado.verificarSiTermino(self) }

    method terminarGanando() {
        estado = ganada
        jardinero.frenar()
        cronometro.parar()
        selectorDeNiveles.desbloquearSiguienteA(nivel)
        self.mostrarCartel()
    }

    method mostrarCartel() {
        game.addVisual(capaDeFinDePartida)
        cartelDeVictoria.mostrar(self.nota())
        navegador.mostrarBarraDeTeclas()
    }

    // Lo llama el jardinero cuando lo mata algun bloque. Si el nivel ya habia terminado,
    // el estado lo ignora.
    method perder(culpable) { estado.perder(self, culpable) }

    // El culpable decide que cartel se muestra: no es lo mismo clavarse con las espinas
    // que caerse por el vidrio.
    method terminarPerdiendo(culpable) {
        estado = perdida
        jardinero.frenar()
        cronometro.parar()
        game.addVisual(capaDeFinDePartida)
        cartelDeDerrota.mostrar(culpable.imagenDeDerrota())
        navegador.mostrarBarraDeTeclas()
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
        if (game.hasVisual(capaDeFinDePartida)) game.removeVisual(capaDeFinDePartida)
    }

    method presionarDireccion(direccion) { estado.presionarDireccion(self, direccion) }

    method presionarReiniciar() {
        self.ocultar()
        self.mostrar()
    }

    method presionarVolver() { navegador.irA(selectorDeNiveles) }
    method presionarJugar() {}
    method presionarNivel(numero) {}
    method presionarSiguiente() { estado.presionarSiguiente(self) }

    method irAlNivelSiguiente() {
        selectorDeNiveles.niveles()
            .filter({ otro => otro.numero() == nivel.numero() + 1 })
            .forEach({ siguiente => self.jugar(siguiente) })
    }
}
