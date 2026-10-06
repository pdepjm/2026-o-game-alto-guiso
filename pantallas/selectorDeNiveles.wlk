import wollok.game.*
import pantallas.menuPrincipal.*
import pantallas.navegador.*
import pantallas.boton.*
import utils.manager.*
import juego.partida.*
import niveles.mapa1.*
import niveles.mapa2.*
import niveles.mapa3.*
import juego.escalaTablero.*

object selectorDeNiveles {
    // Los mapas, en el mismo orden que los botones: la tecla 1 elige el primero
    const mapas = [mapa1, mapa2, mapa3]

    const botones = [
        new Boton(position = escalaTablero.posicionCelda(4, 7), image = assetsManager.botonNivel1()),
        new Boton(position = escalaTablero.posicionCelda(12, 7), image = assetsManager.botonNivel2()),
        new Boton(position = escalaTablero.posicionCelda(8, 5), image = assetsManager.botonNivel3()),
        new Boton(position = escalaTablero.posicionCelda(1, 1), image = assetsManager.botonVolver())
    ]

    method mostrar() {
        game.addVisual(fondoMenu)
        botones.forEach({ boton => game.addVisual(boton) })
    }

    method ocultar() {
        game.removeVisual(fondoMenu)
        botones.forEach({ boton => game.removeVisual(boton) })
    }

    method presionarJugar() {}
    method presionarVolver() { navegador.irA(menuPrincipal) }
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}

    method presionarNivel(numero) {
        partida.nivel(mapas.get(numero - 1))
        navegador.irA(partida)
    }
}
