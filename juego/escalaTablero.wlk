import wollok.game.*

object escalaTablero {
    const property factor = 4

    method posicionCelda(x, y) = game.at(x * factor, y * factor)
    method anchoEnCeldas() = game.width().div(factor)
    method altoEnCeldas() = game.height().div(factor)
}
