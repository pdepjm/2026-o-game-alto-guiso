import wollok.game.*
import screens.mainMenu.*
import screens.levelSelect.*
import maps.map1.*
import maps.player.*

object entradaTeclado {
  var pantalla = "menu"

  method entradasDelTeclado(){
    keyboard.j().onPressDo {
      if (pantalla == "menu") {
        menuPrincipal.ocultar()
        niveles.mostrar()
        pantalla = "niveles"
      }
    }

    keyboard.c().onPressDo {}

    keyboard.q().onPressDo {}

    keyboard.num1().onPressDo {
      if (pantalla == "niveles") {
        menuPrincipal.ocultar()
        niveles.ocultar()
        mapa1.jugar()
        pantalla = "mapa1"
      }
    }

    keyboard.num2().onPressDo {
      if (pantalla == "niveles") {
        menuPrincipal.ocultar()
        niveles.mostrar()
      }
    }

    keyboard.v().onPressDo {
      if (pantalla == "niveles") {
        niveles.volver()
        pantalla = "menu"
      }
    }

    keyboard.up().onPressDo {
      if (pantalla == "mapa1") {
        jugador.moverArriba()
      }
    }

    keyboard.down().onPressDo {
      if (pantalla == "mapa1") {
        jugador.moverAbajo()
      }
    }

    keyboard.left().onPressDo {
      if (pantalla == "mapa1") {
        jugador.moverIzquierda()
      }
    }

    keyboard.right().onPressDo {
      if (pantalla == "mapa1") {
        jugador.moverDerecha()
      }
    }
  }
}