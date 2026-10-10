import wollok.game.*
import pantallas.navegador.*
import utils.manager.*
import juego.escalaTablero.*

// La barra de abajo con las teclas que se pueden apretar. No sabe qué pantalla está activa:
// se lo pregunta a la pantalla actual, y cada una contesta con sus propias teclas.
object barraDeTeclas {
    method position() = escalaTablero.posicionCelda(4, 0)
    method text() = navegador.actual().ayuda()
    method textColor() = assetsManager.colorDelTexto()
}

// Cuenta los segundos que lleva el nivel. Lo arranca y lo para la partida.
object cronometro {
    var property segundos = 0

    method position() = escalaTablero.posicionCelda(2, 1)
    method text() = "Tiempo: " + segundos + "s"
    method textColor() = assetsManager.colorDelTexto()

    method arrancar() {
        segundos = 0
        game.onTick(1000, "cronometro", { segundos += 1 })
    }

    method parar() { game.removeTickEvent("cronometro") }
}

// El cartel grande que aparece al ganar.
object cartelDeVictoria {
    method position() = escalaTablero.posicionCelda(6, 5)
    method image() = assetsManager.cartelVictoria()
}

// El texto que va encima del cartel. Va aparte para poder centrarlo sobre la madera:
// el texto de un visual se dibuja desde su posición, no en el medio de su imagen.
object textoDeVictoria {
    var property text = ""

    method position() = escalaTablero.posicionCelda(9, 6)
    method textColor() = assetsManager.colorDelTexto()
}
