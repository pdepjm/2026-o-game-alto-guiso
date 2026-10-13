import wollok.game.*
import pantallas.navegador.*
import utils.manager.*

// Todo lo que el jugador lee en pantalla.
//
// Ojo con una limitación del motor: Wollok Game dibuja TODOS los textos en 12 píxeles
// y no hay forma de agrandarlos desde el código (solo nos pregunta text() y textColor()).
// En un tablero de 1680x960 eso no se lee, así que acá no usamos textos: usamos imágenes
// que ya traen las letras dibujadas adentro.
//
// Las posiciones van con game.at(...) en vez de escalaTablero.posicionCelda(...) porque
// la interfaz necesita acomodarse más fino que una celda del tablero.

// La barra de abajo con las teclas que se pueden apretar. No sabe qué pantalla está
// activa: se lo pregunta a la pantalla actual, y cada una contesta con su propia imagen.
object barraDeTeclas {
    method position() = game.at(12, 0)
    method image() = navegador.actual().imagenDeTeclas()
}

// Cuenta los segundos que lleva el nivel. Lo arranca y lo para la partida.
object cronometro {
    var property segundos = 0

    method arrancar() {
        segundos = 0
        game.onTick(1000, "cronometro", { segundos += 1 })
    }

    method parar() { game.removeTickEvent("cronometro") }
}

// Una cifra del cronómetro. Cada una mira una posición distinta del número: la potencia
// dice cuál (100 las centenas, 10 las decenas, 1 las unidades). Son instancias de una
// misma clase porque todas se comportan igual, solo cambia qué cifra les toca.
class Digito {
    const property position
    const property potencia

    method valor() = cronometro.segundos().div(potencia) % 10

    // Los ceros de adelante no se dibujan, así 42 segundos se lee "42" y no "042"
    method seVe() = potencia == 1 || cronometro.segundos() >= potencia

    method image() = if (self.seVe()) assetsManager.digito(self.valor()) else assetsManager.digitoVacio()
}

object etiquetaDelTiempo {
    method position() = game.at(2, 8)
    method image() = assetsManager.etiquetaTiempo()
}

// El cronómetro como se ve mientras jugás: el cartelito "TIEMPO" y sus tres cifras.
object relojDePantalla {
    const partes = [
        etiquetaDelTiempo,
        new Digito(position = game.at(2, 4), potencia = 100),
        new Digito(position = game.at(5, 4), potencia = 10),
        new Digito(position = game.at(8, 4), potencia = 1)
    ]

    method mostrar() { partes.forEach({ parte => game.addVisual(parte) }) }

    method ocultar() {
        partes.forEach({ parte => if (game.hasVisual(parte)) game.removeVisual(parte) })
    }
}

// La tabla de madera del cartel de victoria, con el "GANASTE!" ya dibujado.
object fondoDeVictoria {
    method position() = game.at(20, 13)
    method image() = assetsManager.cartelVictoria()
}

// La medalla con la nota. La nota la decide el nivel y se la pasa la partida al ganar.
object medalla {
    var property nota = "S"

    method position() = game.at(50, 20)
    method image() = assetsManager.medalla(nota)
}

// El cartel grande que aparece al ganar. Lo único que cambia de una partida a otra es
// el tiempo y la nota, así que esas dos cosas van encima del cartel como imágenes
// aparte: las cifras del cronómetro y la medalla.
object cartelDeVictoria {
    const partes = [
        fondoDeVictoria,
        new Digito(position = game.at(29, 20), potencia = 100),
        new Digito(position = game.at(32, 20), potencia = 10),
        new Digito(position = game.at(35, 20), potencia = 1),
        medalla
    ]

    method mostrar(unaNota) {
        medalla.nota(unaNota)
        partes.forEach({ parte => game.addVisual(parte) })
    }

    method ocultar() {
        partes.forEach({ parte => if (game.hasVisual(parte)) game.removeVisual(parte) })
    }
}

// El cartel que aparece al perder. Es más simple que el de victoria: no muestra ni
// tiempo ni nota, así que es una sola imagen con todo el texto adentro. Hay una por
// motivo, y la elige el bloque que mató al jardinero.
object cartelDeDerrota {
    // La imagen la pone el bloque que mato al jardinero
    var property image = assetsManager.cartelDerrotaEspinas()

    method position() = game.at(20, 13)

    method mostrar(unaImagen) {
        image = unaImagen
        game.addVisual(self)
    }

    method ocultar() { if (game.hasVisual(self)) game.removeVisual(self) }
}
