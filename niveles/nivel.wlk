import utils.manager.*

// Un nivel del juego: su dibujo, si ya está desbloqueado y cuánto tiempo se considera "rápido".
// Todos los niveles se comportan igual, por eso son instancias de una misma clase.
class Nivel {
    const property numero
    const property mapa
    // Segundos que se consideran una vuelta perfecta. De acá salen las notas.
    const property tiempoIdeal
    var property desbloqueado = false

    // El cartel del selector cambia según el nivel esté bloqueado o no
    method imagenDelBoton() =
        if (desbloqueado) assetsManager.botonDeNivel(numero) else assetsManager.botonBloqueado(numero)

    method desbloquear() { desbloqueado = true }

    // S si lo hizo en el tiempo ideal, y va bajando a medida que tarda más
    method notaPara(segundos) =
        if (segundos <= tiempoIdeal) "S"
        else if (segundos <= tiempoIdeal * 2) "A"
        else if (segundos <= tiempoIdeal * 3) "B"
        else if (segundos <= tiempoIdeal * 4) "C"
        else "D"
}
