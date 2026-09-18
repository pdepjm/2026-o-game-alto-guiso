import wollok.game.*
import screens.mainMenu.menuPrincipal
import utils.manager.*

object nivel1 {
    method position() = game.at(70, 54)
    method image() = assetsManager.botonNivel1()
}

object nivel2 {
    method position() = game.at(90, 54)
    method image() = assetsManager.botonNivel1()
}

object niveles {
    method mostrar() {
        game.addVisual(nivel1)
        game.addVisual(nivel2)
    }

    method ocultar() {
        game.removeVisual(nivel1)
        game.removeVisual(nivel2)
    }

    method volver(){
        self.ocultar()
        menuPrincipal.mostrar()
    }

    method iniciarNivel1(){}

}