import wollok.game.*
import utils.manager.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*
import pantallas.configuracion.*
import pantallas.fondoMenu.*
import pantallas.boton.*
import juego.escalaTablero.*

// El título del juego, arriba del menú.
object tituloDelJuego {
    method position() = game.at(12, 36)
    method image() = assetsManager.tituloDelJuego()
}

object menuPrincipal {
    // Los carteles van en una sola columna, centrados y uno abajo del otro. Las posiciones
    // van con game.at(...) porque la interfaz se acomoda más fino que una celda del tablero.
    const botones = [
        new Boton(position = game.at(34, 22), image = assetsManager.botonJugar()),
        new Boton(position = game.at(34, 15), image = assetsManager.botonConfiguracion()),
        new Boton(position = game.at(34, 8), image = assetsManager.botonSalir())
    ]

    method imagenDeTeclas() = assetsManager.teclasDelMenu()

    method mostrar(){
        game.addVisual(fondoMenu)
        game.addVisual(tituloDelJuego)
        botones.forEach({ boton => game.addVisual(boton) })
    }

    method ocultar(){
        game.removeVisual(fondoMenu)
        game.removeVisual(tituloDelJuego)
        botones.forEach({ boton => game.removeVisual(boton) })
    }

    method presionarJugar() { navegador.irA(selectorDeNiveles) }
    method presionarConfiguracion() { navegador.irA(configuracion) }
    method presionarVolver() {}
    method presionarNivel(numero) {}
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
    method presionarSiguiente() {}
}
