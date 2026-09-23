import wollok.game.*
import utils.manager.*
import pantallas.navegador.*
import pantallas.selectorDeNiveles.*

object jugar {
    method position() = game.at(11, 6)
    method image() = assetsManager.botonJugar()
}

object configuracion {
    method position() = game.at(11, 4)
    method image() = assetsManager.botonConfiguracion()
}

object salir {
    method position() = game.at(11, 2)
    method image() = assetsManager.botonSalir()
}

object fondoMenu {
    method position() = game.origin()
    method image() = assetsManager.fondoMenu()
}

object menuPrincipal {

    method mostrar(){
        game.addVisual(fondoMenu)
        game.addVisual(jugar)
        game.addVisual(configuracion)
        game.addVisual(salir)
    }

    method ocultar(){
        game.removeVisual(fondoMenu)
        game.removeVisual(jugar)
        game.removeVisual(configuracion)
        game.removeVisual(salir)
    }

    method presionarJugar() { navegador.irA(selectorDeNiveles) }
    method presionarVolver() {}
    method presionarNivel(numero) {}
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
}
