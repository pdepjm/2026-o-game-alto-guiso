import wollok.game.*
import utils.manager.*
import juego.semillas.*
import juego.direcciones.*


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

class Esquina {
    const property position
    const property giro

    method image() = giro.imagen()

    method esTraspasable() = true

    method pisadoPor(jardinero) {
        jardinero.girar(giro)
    }
}

// Pincha al jardinero: si las pisa, pierde el nivel y hay que reintentar
class Espinas {
    const property position

    method image() = assetsManager.espinas()

    method esTraspasable() = true

    method pisadoPor(jardinero) {
        jardinero.morir(self)
    }

    // Cada bloque que puede matar al jardinero dice como se ve su cartel de derrota
    method imagenDeDerrota() = assetsManager.cartelDerrotaEspinas()
}

// Se puede pisar y frena el deslizamiento: una vez arriba, el jardinero sube y baja
// de a un escalón por vez. Si se mueve para los costados se baja y vuelve a deslizarse.
class Escalera {
    const property position

    method image() = assetsManager.escalera()

    method esTraspasable() = true

    method pisadoPor(jardinero) {
        jardinero.subirseAEscalera()
    }
}

// Un túnel de topo. Los agujeros se emparejan de a dos en el orden en que aparecen en
// el mapa, y el jardinero que cae en uno sale por el otro sin cortar el movimiento.
class Agujero {
    const property position

    // Tiene 0 o 1 agujero adentro: el otro extremo del túnel. Es una lista y no un
    // "pareja o nada" para no tener que preguntar si existe: si el nivel dejó un
    // agujero sin pareja, el forEach no hace nada y listo.
    const parejas = []

    method emparejarCon(otroAgujero) { parejas.add(otroAgujero) }

    method image() = assetsManager.agujero()

    method esTraspasable() = true

    method pisadoPor(jardinero) {
        parejas.forEach({ otroAgujero => jardinero.caerEn(otroAgujero.position()) })
    }
}

// Un piso de vidrio: aguanta una sola pasada. La primera vez que lo pisan queda rajado,
// y si el jardinero vuelve a pasar por ahí se cae y pierde el nivel.
class Vidrio {
    const property position
    var property rajado = false

    method image() = if (rajado) assetsManager.vidrioRoto() else assetsManager.vidrio()

    // Siempre se puede pisar: lo que cambia es qué pasa al pisarlo
    method esTraspasable() = true

    method pisadoPor(jardinero) {
        if (rajado) jardinero.morir(self) else rajado = true
    }

    method imagenDeDerrota() = assetsManager.cartelDerrotaVidrio()
}
