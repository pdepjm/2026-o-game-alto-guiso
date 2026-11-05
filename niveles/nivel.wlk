// Un nivel del juego: su número, su dibujo y cuánto tiempo se considera "rápido".
// Todos los niveles se comportan igual, por eso son instancias de una misma clase.
//
// Un nivel no sabe si está desbloqueado, y es a propósito: eso no es una característica
// suya sino del avance de la partida. La lista de los desbloqueados la tiene el selector,
// que es quien lleva la cuenta de hasta dónde llegó el jugador.
class Nivel {
    const property numero
    const property mapa
    // Segundos que se consideran una vuelta perfecta. De acá salen las notas.
    const property tiempoIdeal

    // S si lo hizo en el tiempo ideal, y va bajando a medida que tarda más
    method notaPara(segundos) =
        if (segundos <= tiempoIdeal) "S"
        else if (segundos <= tiempoIdeal * 2) "A"
        else if (segundos <= tiempoIdeal * 3) "B"
        else if (segundos <= tiempoIdeal * 4) "C"
        else "D"
}
