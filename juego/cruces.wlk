import wollok.game.*
import juego.semillas.*

object cruz1 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}

object cruz2 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}

object cruz3 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}

object cruz4 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}

object cruz5 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}

object cruz6 {
    var property position = game.origin()
    var property semilla = semillaRoja
    var property florecida = false

    method image() = if (florecida) semilla.imagenFlor() else semilla.imagenCruz()
    method pisadoPor(jardinero) { jardinero.plantarEn(self) }
    method recibir(unaSemilla) { if (unaSemilla == semilla) florecida = true }
}
