import wollok.game.*
import utils.manager.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*
import pantallas.boton.*

// El fondo de las pantallas de menú. Es único, por eso es un objeto y no una instancia.
object fondoMenu {
    method position() = game.origin()
    method image() = assetsManager.fondoMenu()
}

object menuPrincipal {
    const botones = [
        new Boton(position = game.at(11, 6), image = assetsManager.botonJugar()),
        new Boton(position = game.at(11, 4), image = assetsManager.botonConfiguracion()),
        new Boton(position = game.at(11, 2), image = assetsManager.botonSalir())
    ]

    method mostrar(){
        game.addVisual(fondoMenu)
        botones.forEach({ boton => game.addVisual(boton) })
    }

    method ocultar(){
        game.removeVisual(fondoMenu)
        botones.forEach({ boton => game.removeVisual(boton) })
    }

    method presionarJugar() { navegador.irA(selectorDeNiveles) }
    method presionarVolver() {}
    method presionarNivel(numero) {}
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
}
