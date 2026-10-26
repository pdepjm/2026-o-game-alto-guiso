import utils.manager.*

object nivelBloqueado {
    method imagenDelBoton(nivel) = assetsManager.botonBloqueado(nivel.numero())
    method siguienteEstado() = nivelDesbloqueado
}

object nivelDesbloqueado {
    method imagenDelBoton(nivel) = assetsManager.botonDeNivel(nivel.numero())
    method siguienteEstado() = self
}

// Un nivel del juego: su dibujo, si ya está desbloqueado y cuánto tiempo se considera "rápido".
// Todos los niveles se comportan igual, por eso son instancias de una misma clase.
class Nivel {
    const property numero
    const property mapa
    // Segundos que se consideran una vuelta perfecta. De acá salen las notas.
    const property tiempoIdeal
    var property estado = nivelBloqueado

    method imagenDelBoton() = estado.imagenDelBoton(self)

    method desbloquear() { estado = estado.siguienteEstado() }

    // S si lo hizo en el tiempo ideal, y va bajando a medida que tarda más
    method notaPara(segundos) =
        if (segundos <= tiempoIdeal) "S"
        else if (segundos <= tiempoIdeal * 2) "A"
        else if (segundos <= tiempoIdeal * 3) "B"
        else if (segundos <= tiempoIdeal * 4) "C"
        else "D"
}
