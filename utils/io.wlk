import wollok.game.*
import pantallas.navegador.*
import juego.direcciones.*
import utils.sonidos.*
object entradaTeclado {

  method reproducirSonidoDeTecla() {
    sonidos.reproducirSonidoDeTecla()
  }

  method entradasDelTeclado(){
    keyboard.j().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarJugar() }
    keyboard.c().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarConfiguracion() }
    keyboard.v().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarVolver() }
    keyboard.n().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarSiguiente() }
    keyboard.r().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarReiniciar() }
    keyboard.num1().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarNivel(1) }
    keyboard.num2().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarNivel(2) }
    keyboard.num3().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarNivel(3) }
    keyboard.num4().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarNivel(4) }
    keyboard.num5().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarNivel(5) }

    keyboard.up().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarDireccion(arriba) }
    keyboard.down().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarDireccion(abajo) }
    keyboard.left().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarDireccion(izquierda) }
    keyboard.right().onPressDo { self.reproducirSonidoDeTecla() navegador.actual().presionarDireccion(derecha) }

    keyboard.q().onPressDo { self.reproducirSonidoDeTecla() game.stop() }
  }
}
