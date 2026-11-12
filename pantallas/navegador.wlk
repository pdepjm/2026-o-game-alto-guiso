import wollok.game.*
import pantallas.menuPrincipal.*
import pantallas.hud.*

object navegador {
  var actual = menuPrincipal

  method actual() = actual

  method iniciar() {
    actual.mostrar()
    self.mostrarBarraDeTeclas()
  }

  method irA(pantalla) {
    actual.ocultar()
    actual = pantalla
    pantalla.mostrar()
    self.mostrarBarraDeTeclas()
  }

  // La barra va siempre arriba de todo lo demás, así que se vuelve a agregar
  // después de dibujar la pantalla nueva. Si no, el fondo del menú la taparía.
  method mostrarBarraDeTeclas() {
    if (game.hasVisual(barraDeTeclas)) game.removeVisual(barraDeTeclas)
    game.addVisual(barraDeTeclas)
  }
}
