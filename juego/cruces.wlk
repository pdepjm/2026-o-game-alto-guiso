import wollok.game.*
import juego.semillas.*

// Los lugares marcados donde hay que plantar. Cada cruz sabe qué semilla le corresponde:
// si el jardinero pasa con esa semilla, se convierte en la flor de ese color.
class Cruz {
    var property position
    var property semilla
    var property florecida = false

    // La imagen sale de la semilla que le toca, y cambia sola al florecer
    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()

    // Se puede caminar por encima: la cruz no frena al jardinero
    method esTraspasable() = true

    // Al pisarla, le pide al jardinero que plante lo que tenga en la mano
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }

    // Se lo manda la semilla al plantar. Solo florece si es la de su color
    method recibir(semillaPlantada) {
        if (semillaPlantada == semilla) {
            florecida = true
        }
    }
}
