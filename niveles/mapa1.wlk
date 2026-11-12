import niveles.nivel.*

// Nivel 1 (tutorial): agarrar la semilla roja para la cruz roja y la azul para la cruz azul.
// Es el único al que se puede entrar al abrir el juego: el selector arranca con él
// como único nivel desbloqueado.
const mapa1 = new Nivel(
    numero = 1,
    tiempoIdeal = 15,
    mapa = [
        "###########",
        "#J   r   R#",
        "#    #    #",
        "#A        #",
        "#    a   ##",
        "###########"
    ]
)
