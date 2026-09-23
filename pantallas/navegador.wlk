import pantallas.menuPrincipal.*
object navegador {
  var actual = menuPrincipal

  method actual() = actual

  method iniciar() { actual.mostrar() }

  method irA(pantalla) {
    actual.ocultar()
    actual = pantalla
    pantalla.mostrar()
  }
}
