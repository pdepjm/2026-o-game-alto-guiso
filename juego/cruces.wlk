import wollok.game.*
import juego.semillas.*

class Cruz{
    var property position
    var property semilla
    var property florecida = false

    // Interfaz para el movimiento del jardinero
    method esTraspasable() = true
    
    // El jardinero le  manda este mensaje al pisar la celda
    // Como la cruz no frena ni quita items al pisarla (por ahora), el metodo queda vacio,
    // pero debe existir para respetar el contrato y que no rompa el juego
    method pisadoPor(jardinero) {}

    // Este metodo es llamado por la semilla cuando el jardinero planta
    method recibir(semillaPlantada) {
        if (semillaPlantada == semilla) {
            florecida = true
        }
    }
}