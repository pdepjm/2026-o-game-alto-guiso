import wollok.game.*
import juego.semillas.*
import juego.bloques.*

// Los lugares marcados donde hay que plantar. Cada cruz sabe qué semilla le corresponde:
// si el jardinero pasa con esa semilla, se convierte en la flor de ese color.
//
// Hereda de Bloque igual que el resto de las cosas del tablero: de ahí saca position y
// esTraspasable() = true, porque la cruz no frena al jardinero.
class Cruz inherits Bloque {
    var property semilla
    var property florecida = false

    // La imagen sale de la semilla que le toca, y cambia sola al florecer
    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()

    // Al pisarla, le pide al jardinero que plante lo que tenga en la mano
    override method pisadoPor(jardinero) { jardinero.plantarEn(self) }

    // Se lo manda la semilla al plantar. Solo florece si es la de su color
    method recibir(semillaPlantada) {
        if (semillaPlantada == semilla) {
            florecida = true
        }
    }
}
