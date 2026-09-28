import wollok.game.*
import utils.manager.*
import juego.semillas.*

class Piedra {
    var property position

    // Bloquea el paso igual que una valla
    method esTraspasable() = false
    method image() = "piedra.png" 

    method pisadoPor(jardinero) { }
}

class CharcoDeBarro {
    var property position

    // Se puede pisar, no frena el movimiento
    method esTraspasable() = true
    method image() = "barro.png"

    method pisadoPor(jardinero) {
        jardinero.recoger(sinSemilla)
    }
}