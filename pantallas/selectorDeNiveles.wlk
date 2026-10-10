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

// El cartel de un nivel en el selector. Su imagen no es fija: se la pide al nivel,
// que la cambia según esté bloqueado o desbloqueado.
class BotonDeNivel {
    const property position
    const nivel

    method image() = nivel.imagenDelBoton()
}

object selectorDeNiveles {
    // Los niveles, en el mismo orden que los botones: la tecla 1 elige el primero
    const property niveles = [mapa1, mapa2, mapa3]

    const botones = [
        new BotonDeNivel(position = escalaTablero.posicionCelda(2, 7), nivel = mapa1),
        new BotonDeNivel(position = escalaTablero.posicionCelda(9, 7), nivel = mapa2),
        new BotonDeNivel(position = escalaTablero.posicionCelda(16, 7), nivel = mapa3)
    ]

    const botonVolver = new Boton(position = escalaTablero.posicionCelda(1, 1), image = assetsManager.botonVolver())

    method mostrar() {
        game.addVisual(fondoMenu)
        botones.forEach({ boton => game.addVisual(boton) })
        game.addVisual(botonVolver)
    }

    method ocultar() {
        game.removeVisual(fondoMenu)
        botones.forEach({ boton => game.removeVisual(boton) })
        game.removeVisual(botonVolver)
    }

    // Deja entrar solo a los niveles desbloqueados
    method presionarNivel(numero) {
        const elegido = niveles.get(numero - 1)
        if (elegido.desbloqueado()) {
            partida.jugar(elegido)
        }
    }

    // Cuando se gana un nivel, se abre el siguiente. Si no hay ninguno con ese número
    // (por ejemplo, al ganar el último), el filter no encuentra nada y no pasa nada.
    method desbloquearSiguienteA(nivel) {
        niveles.filter({ otro => otro.numero() == nivel.numero() + 1 })
               .forEach({ siguiente => siguiente.desbloquear() })
    }

    method presionarJugar() {}
    method presionarVolver() { navegador.irA(menuPrincipal) }
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
}
