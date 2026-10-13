import niveles.nivel.*

// Nivel 4: aparecen las escaleras, las espinas y el charco de barro.
// La cruz azul está encerrada arriba del todo: la única forma de llegar es frenando en
// la escalera de la fila del medio y subiendo escalón por escalón.
// Se desbloquea al completar el nivel 3.
const mapa4 = new Nivel(
    numero = 4,
    tiempoIdeal = 45,
    mapa = [
        "###############",
        "#J    #a#     #",
        "#     #E#     #",
        "#A    #E#    r#",
        "#E     E     R#",
        "#  X       X  #",
        "#             #",
        "#      B      #",
        "###############"
    ]
)
