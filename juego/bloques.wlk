import wollok.game.*
import utils.manager.*
import utils.sonidos.*
import juego.semillas.*
import juego.direcciones.*


// Los elementos del jardín que no son ni semillas ni cruces.
// Todos entienden los mismos mensajes, así el jardinero los trata a todos igual:
//   position()            -> en qué celda está
//   image()               -> cómo se dibuja
//   esTraspasable()       -> si el jardinero puede entrar a su celda
//   pisadoPor(jardinero)  -> qué le pasa al jardinero al pisarlo

// Rodea el jardín y arma el laberinto de cada nivel

class Bloque{
    var property position

    // Comportamiento por defecto: la mayoria se puede pisar
    method esTraspasable() = true
    
    // Otro comportamiento por defecto: la mayoria no hace nada al ser pisado
    method pisadoPor(jardinero){}
}


class Valla inherits Bloque {
    method image() = assetsManager.valla() // Para que cada valla se pueda mostrar

    // Redefinimos porque la valla no se puede traspasar
    override method esTraspasable() = false
}

class Piedra inherits Bloque {
    method image() = assetsManager.piedra()

    // Redefinimos porque la piedra no se puede traspasar
    override method esTraspasable() = false
}

// Se puede pisar, no frena el movimiento, pero le arruina la semilla al jardinero
class CharcoDeBarro inherits Bloque {
    method image() = assetsManager.barro()

    // Redefinimos el efecto al pisar
    override method pisadoPor(jardinero) {
        jardinero.recoger(sinSemilla)
    }
}

class Esquina inherits Bloque {
    const property giro

    method image() = giro.imagen()

    override method pisadoPor(jardinero) {
        jardinero.girar(giro)
    }
}

// Pincha al jardinero: si las pisa, pierde el nivel y hay que reintentar
class Espinas inherits Bloque {
    method image() = assetsManager.espinas()

    override method pisadoPor(jardinero) {
        jardinero.morir(self)
    }

    // Cada bloque que puede matar al jardinero dice como se ve su cartel de derrota
    method imagenDeDerrota() = assetsManager.cartelDerrotaEspinas()
}

// Se puede pisar y frena el deslizamiento: una vez arriba, el jardinero sube y baja
// de a un escalón por vez. Si se mueve para los costados se baja y vuelve a deslizarse.
class Escalera inherits Bloque {
    method image() = assetsManager.escalera()

    override method pisadoPor(jardinero) {
        jardinero.subirseAEscalera()
    }
}

// Un túnel de topo. Los agujeros se emparejan de a dos en el orden en que aparecen en
// el mapa, y el jardinero que cae en uno sale por el otro sin cortar el movimiento.
class Agujero inherits Bloque {
    // Tiene 0 o 1 agujero adentro: el otro extremo del túnel. Es una lista y no un
    // "pareja o nada" para no tener que preguntar si existe: si el nivel dejó un
    // agujero sin pareja, el forEach no hace nada y listo.
    const parejas = []

    method emparejarCon(otroAgujero) { parejas.add(otroAgujero) }

    method image() = assetsManager.agujero()

    override method pisadoPor(jardinero) {
        parejas.forEach({ otroAgujero => jardinero.caerEn(otroAgujero.position()) })
    }
}

object vidrioEntero {
    method image() = assetsManager.vidrio()
    method pisadoPor(vidrio, jardinero) {
        vidrio.estado(vidrioRajado)
        sonidos.reproducirSonidoDeHielo()
    }
}

object vidrioRajado {
    method image() = assetsManager.vidrioRoto()
    method pisadoPor(vidrio, jardinero) { jardinero.morir(vidrio) }
}

// Un piso de vidrio: aguanta una sola pasada. La primera vez que lo pisan queda rajado,
// y si el jardinero vuelve a pasar por ahí se cae y pierde el nivel.
class Vidrio inherits Bloque{
    var property estado = vidrioEntero

    method image() = estado.image()

    override method pisadoPor(jardinero) { estado.pisadoPor(self, jardinero) }

    method imagenDeDerrota() = assetsManager.cartelDerrotaVidrio()
}
