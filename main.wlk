import wollok.game.*
import pantallas.navegador.*
import utils.io.*
import utils.manager.*

object main {

  method iniciar(){
    game.width(21)
    game.height(12)
    game.cellSize(80)
    game.title("Flor de Quilombo")
    game.boardGround(assetsManager.fondoCesped())
    navegador.iniciar()
    entradaTeclado.entradasDelTeclado()

    game.start()
  }
}
