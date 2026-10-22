import wollok.game.*
import pantallas.navegador.*
import pantallas.menuPrincipal.*
import pantallas.boton.*
import pantallas.fondoMenu.*
import utils.manager.*

object configuracion {
    const botonVolver = new Boton(position = game.at(2, 42), image = assetsManager.botonVolver())

    method imagenDeTeclas() = assetsManager.teclasDeConfiguracion()

    method mostrar() {
        game.addVisual(fondoMenu)
        game.addVisual(botonVolver)
    }

    method ocultar() {
        game.removeVisual(fondoMenu)
        game.removeVisual(botonVolver)
    }

    method presionarVolver() { navegador.irA(menuPrincipal) }
    method presionarJugar() {}
    method presionarConfiguracion() {}
    method presionarNivel(numero) {}
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
    method presionarSiguiente() {}
}
