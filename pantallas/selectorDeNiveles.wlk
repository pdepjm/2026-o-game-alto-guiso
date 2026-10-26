import wollok.game.*
import pantallas.menuPrincipal.*
import pantallas.fondoMenu.*
import pantallas.navegador.*
import pantallas.boton.*
import utils.manager.*
import juego.partida.*
import niveles.mapa1.*
import niveles.mapa2.*
import niveles.mapa3.*
import niveles.mapa4.*
import niveles.mapa5.*
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
    const property niveles = [mapa1, mapa2, mapa3, mapa4, mapa5]
    const property nivelesDesbloqueados = [mapa1]

    // Tres carteles arriba y dos abajo, centrados. Las posiciones van en subceldas
    // (game.at) porque la interfaz se acomoda mas fino que una celda del tablero.
    const botones = [
        new BotonDeNivel(position = game.at(6, 28), nivel = mapa1),
        new BotonDeNivel(position = game.at(34, 28), nivel = mapa2),
        new BotonDeNivel(position = game.at(62, 28), nivel = mapa3),
        new BotonDeNivel(position = game.at(20, 16), nivel = mapa4),
        new BotonDeNivel(position = game.at(48, 16), nivel = mapa5)
    ]

    const botonVolver = new Boton(position = game.at(2, 42), image = assetsManager.botonVolver())

    method imagenDeTeclas() = assetsManager.teclasDelSelector()

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
        if (nivelesDesbloqueados.contains(elegido)) {
            partida.jugar(elegido)
        }
    }

    // Cuando se gana un nivel, se abre el siguiente. Si no hay ninguno con ese número
    // (por ejemplo, al ganar el último), el filter no encuentra nada y no pasa nada.
    method desbloquearSiguienteA(nivel) {
        niveles.filter({ otro => otro.numero() == nivel.numero() + 1 })
               .forEach({ siguiente => self.desbloquear(siguiente) })
    }

    method desbloquear(nivel) {
        if (!nivelesDesbloqueados.contains(nivel)) {
            nivelesDesbloqueados.add(nivel)
            nivel.desbloquear()
        }
    }

    method presionarJugar() {}
    method presionarVolver() { navegador.irA(menuPrincipal) }
    method presionarDireccion(direccion) {}
    method presionarReiniciar() {}
    method presionarSiguiente() {}
}
