import wollok.game.*
import screens.mainMenu.*
import utils.io.*

object main {

  method iniciar(){
    game.width(120)
    game.height(80)
    game.cellSize(30)
    game.title("Flor de Quilombo")
    game.boardGround("fondoMenu2.png")
    menuPrincipal.mostrar()
    entradaTeclado.entradasDelTeclado()

    game.start() // Este siempre es lo ultimo que se pone si no no carga lo anterior
  }
}




