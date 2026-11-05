import niveles.nivel.*

// Nivel 3: usa las esquinas, que cambian la dirección del jardinero al pisarlas.
// Se desbloquea al completar el nivel 2.
const mapa3 = new Nivel(
    numero = 3,
    tiempoIdeal = 90,
    mapa = [
        "###############",
        "#J R  a   a  D#",
        "#             #",
        "#r            #",
        "#             #",
        "#r            #",
        "#M            #",
        "#   m   m  A O#",
        "###############"
    ]
)
