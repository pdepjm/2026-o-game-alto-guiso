import wollok.game.*
import juego.semillas.*
import juego.bloques.*

// En qué estado está una cruz. Es el mismo caso que el vidrio: lo único que cambia es
// cómo se dibuja y qué pasa cuando le plantan algo, así que en vez de un booleano con
// ifs hay un objeto por estado y la cruz le delega las dos cosas.

object sinFlorecer {
    method imagenPara(semilla) = semilla.imagenCruz()

    // Solo florece si la semilla plantada es la de su color
    method recibir(cruz, semillaPlantada) {
        if (semillaPlantada == cruz.semilla()) cruz.estado(florecida)
    }

    method estaFlorecida() = false
}

object florecida {
    method imagenPara(semilla) = semilla.imagenFlor()

    // Una vez florecida ya no cambia más
    method recibir(cruz, semillaPlantada) {}

    method estaFlorecida() = true
}

// Los lugares marcados donde hay que plantar. Cada cruz sabe qué semilla le corresponde:
// si el jardinero pasa con esa semilla, se convierte en la flor de ese color.
//
// Hereda de Bloque igual que el resto de las cosas del tablero: de ahí saca position y
// esTraspasable() = true, porque la cruz no frena al jardinero.
class Cruz inherits Bloque {
    var property semilla
    var property estado = sinFlorecer

    method image() = estado.imagenPara(semilla)

    method florecida() = estado.estaFlorecida()

    // Al pisarla, le pide al jardinero que plante lo que tenga en la mano
    override method pisadoPor(jardinero) { jardinero.plantarEn(self) }

    // Se lo manda la semilla al plantar. Quién decide si florece es el estado.
    method recibir(semillaPlantada) { estado.recibir(self, semillaPlantada) }
}
