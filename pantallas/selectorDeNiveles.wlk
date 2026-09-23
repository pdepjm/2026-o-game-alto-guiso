import wollok.game.*
import pantallas.menuPrincipal.*
import pantallas.navegador.*
import utils.manager.*
import juego.partida.*
import niveles.mapa1.*
import niveles.mapa2.*

object nivel1 {
    method position() = game.at(4, 7)
    method image() = assetsManager.botonNivel1()
}

object nivel2 {
    method position() = game.at(12, 7)
    method image() = assetsManager.botonNivel2()
}

object volver {
    method position() = game.at(1, 1)
    method image() = assetsManager.botonVolver()
}

object selectorDeNiveles {
    const mapas = [mapa1, mapa2]

    method mostrar() {
        game.addVisual(fondoMenu)
        game.addVisual(nivel1)
        game.addVisual(nivel2)
        game.addVisual(volver)
    }

    method ocultar() {
        game.removeVisual(fondoMenu)
        game.removeVisual(nivel1)
        game.removeVisual(nivel2)
        game.removeVisual(volver)
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
