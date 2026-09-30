import wollok.game.*
import utils.manager.*
import juego.semillas.*

// Los elementos del jardín que no son ni semillas ni cruces.
// Todos entienden los mismos mensajes, así el jardinero los trata a todos igual:
//   position()            -> en qué celda está
//   image()               -> cómo se dibuja
//   esTraspasable()       -> si el jardinero puede entrar a su celda
//   pisadoPor(jardinero)  -> qué le pasa al jardinero al pisarlo

// Rodea el jardín y arma el laberinto de cada nivel
class Valla {
    var property position // Cada valla va a tener su propia ubicación

    method image() = assetsManager.valla() // Para que cada valla se pueda mostrar

    // Las vallas bloquean el paso
    method esTraspasable() = false

    // Nunca se la pisa (el jardinero frena antes), pero entiende el mensaje igual que el resto
    method pisadoPor(jardinero) {}
}

// Bloquea el paso igual que una valla, pero en el medio del jardín
class Piedra {
    var property position

    method image() = assetsManager.piedra()

    method esTraspasable() = false

    method pisadoPor(jardinero) {}
}

// Se puede pisar, no frena el movimiento, pero le arruina la semilla al jardinero
class CharcoDeBarro {
    var property position

    method image() = assetsManager.barro()

    method esTraspasable() = true

    method pisadoPor(jardinero) {
        jardinero.recoger(sinSemilla)
    }
}
