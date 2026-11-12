import niveles.nivel.*

// Nivel 5: están todos los bloques juntos.
// Las dos cruces del medio viven en una pieza cerrada: se entra y se sale por los
// agujeros de topo, que son los dos del mapa y por eso quedan emparejados entre sí.
// La cruz amarilla de la derecha pide pasar por el piso de vidrio, que aguanta una
// sola pasada, así que hay que llegar ahí con la semilla amarilla ya en la mano.
// Se desbloquea al completar el nivel 4.
const mapa5 = new Nivel(
    numero = 5,
    tiempoIdeal = 60,
    mapa = [
        "###############",
        "#J           R#",
        "#   #####     #",
        "#H  #rHa#     #",
        "#   #####    E#",
        "#        P   V#",
        "#    X       m#",
        "#A  B    M   O#",
        "###############"
    ]
)
