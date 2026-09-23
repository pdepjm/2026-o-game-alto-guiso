import wollok.game.*
import pantallas.navegador.*
import juego.direcciones.*
object entradaTeclado {

  method entradasDelTeclado(){
    keyboard.j().onPressDo { navegador.actual().presionarJugar() }
    keyboard.v().onPressDo { navegador.actual().presionarVolver() }
    keyboard.r().onPressDo { navegador.actual().presionarReiniciar() }
    keyboard.num1().onPressDo { navegador.actual().presionarNivel(1) }
    keyboard.num2().onPressDo { navegador.actual().presionarNivel(2) }

    keyboard.up().onPressDo { navegador.actual().presionarDireccion(arriba) }
    keyboard.down().onPressDo { navegador.actual().presionarDireccion(abajo) }
    keyboard.left().onPressDo { navegador.actual().presionarDireccion(izquierda) }
    keyboard.right().onPressDo { navegador.actual().presionarDireccion(derecha) }

    keyboard.c().onPressDo {}
    keyboard.q().onPressDo { game.stop() }
  }
}
