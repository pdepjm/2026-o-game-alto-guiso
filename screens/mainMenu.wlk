import wollok.game.*
import utils.manager.*

object jugar {
    method position() = game.at(70, 54)
    method image() = assetsManager.botonJugar()
}

object configuracion {
    method position() = game.at(70, 43)
    method image() = assetsManager.botonConfiguracion()
}

object salir {
    method position() = game.at(70, 32)
    method image() = assetsManager.botonSalir()
}

object menuPrincipal {

    method mostrar(){
        game.addVisual(jugar)
        game.addVisual(configuracion)
        game.addVisual(salir)
    }

    method ocultar(){
        game.removeVisual(jugar)
        game.removeVisual(configuracion)
        game.removeVisual(salir)
    }
}
