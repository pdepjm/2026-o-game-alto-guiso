import wollok.game.*
import utils.manager.*

object semillaRoja {
    var property position = game.origin()

    method letra() = "R"
    method letraCruz() = "r"
    method image() = assetsManager.semillaRoja()
    method imagenCruz() = assetsManager.cruzRoja()
    method imagenFlor() = assetsManager.florRoja()

    method pisadoPor(jardinero) { jardinero.recoger(self) }
    method aplicarEn(cruz) { cruz.recibir(self) }
    method esTraspasable() = true
}

object semillaAzul {
    var property position = game.origin()

    method letra() = "A"
    method letraCruz() = "a"
    method image() = assetsManager.semillaAzul()
    method imagenCruz() = assetsManager.cruzAzul()
    method imagenFlor() = assetsManager.florAzul()

    method pisadoPor(jardinero) { jardinero.recoger(self) }
    method aplicarEn(cruz) { cruz.recibir(self) }
    method esTraspasable() = true
}

object semillaAmarilla {
    var property position = game.origin()

    method letra() = "M"
    method letraCruz() = "m"
    method image() = assetsManager.semillaAmarilla()
    method imagenCruz() = assetsManager.cruzAmarilla()
    method imagenFlor() = assetsManager.florAmarilla()

    method pisadoPor(jardinero) { jardinero.recoger(self) }
    method aplicarEn(cruz) { cruz.recibir(self) }
    method esTraspasable() = true
}

object sinSemilla {
    method aplicarEn(cruz) {}
    method esTraspasable() = true
}