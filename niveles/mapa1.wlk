import niveles.nivel.*

// Nivel 1 (tutorial): agarrar la semilla roja para la cruz roja y la azul para la cruz azul.
// Empieza desbloqueado: es el único al que se puede entrar al abrir el juego.
const mapa1 = new Nivel(
    numero = 1,
    tiempoIdeal = 15,
    estado = nivelDesbloqueado,
    mapa = [
        "###########",
        "#J   r   R#",
        "#    #    #",
        "#A        #",
        "#    a   ##",
        "###########"
    ]
)
