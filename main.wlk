import wollok.game.*
import pantallas.navegador.*
import utils.io.*
import utils.manager.*
import utils.sonidos.*
import juego.escalaTablero.*

object main {
  method iniciar(){
    game.width(21 * escalaTablero.factor())
    game.height(12 * escalaTablero.factor())
    game.cellSize(80.div(escalaTablero.factor()))
    game.title("Flor de Quilombo")
    game.boardGround(assetsManager.fondoCesped())
    navegador.iniciar()
    entradaTeclado.entradasDelTeclado()
    sonidos.iniciar()

    game.start()
  }
}
