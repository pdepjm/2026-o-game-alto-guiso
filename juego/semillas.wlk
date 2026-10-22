import wollok.game.*
import utils.manager.*
import juego.bloques.*

// Las tres semillas hacen exactamente lo mismo: lo único que cambia son su letra en el
// mapa y sus imágenes, o sea datos y no comportamiento. Por eso son tres instancias de
// una misma clase y no tres subclases: no habría nada distinto que redefinir.
//
// Hereda de Bloque, así que ya trae position y esTraspasable() = true.
class Semilla inherits Bloque {
    const property letra
    const property letraCruz
    const property image
    const property imagenCruz
    const property imagenFlor
    const property imagenEnMano

    // El jardinero la levanta al pasar por encima
    override method pisadoPor(jardinero) { jardinero.recoger(self) }

    // Plantarse es cosa de la semilla: la cruz después decide si es de su color
    method aplicarEn(cruz) { cruz.recibir(self) }
}

// Hay una sola semilla de cada color en todo el juego, y eso es a propósito: la cruz
// compara la semilla que le plantaron con la suya, así que tienen que ser el mismo
// objeto. Arrancan en el origen y el mapa las reubica al armar el nivel.
const semillaRoja = new Semilla(
    position = game.origin(),
    letra = "R",
    letraCruz = "r",
    image = assetsManager.semillaRoja(),
    imagenCruz = assetsManager.cruzRoja(),
    imagenFlor = assetsManager.florRoja(),
    imagenEnMano = assetsManager.manoRoja()
)

const semillaAzul = new Semilla(
    position = game.origin(),
    letra = "A",
    letraCruz = "a",
    image = assetsManager.semillaAzul(),
    imagenCruz = assetsManager.cruzAzul(),
    imagenFlor = assetsManager.florAzul(),
    imagenEnMano = assetsManager.manoAzul()
)

const semillaAmarilla = new Semilla(
    position = game.origin(),
    letra = "M",
    letraCruz = "m",
    image = assetsManager.semillaAmarilla(),
    imagenCruz = assetsManager.cruzAmarilla(),
    imagenFlor = assetsManager.florAmarilla(),
    imagenEnMano = assetsManager.manoAmarilla()
)

// La mano vacía del jardinero. Es un concepto único en el juego, así que es un objeto
// y no una clase. Al no hacer nada en aplicarEn, nos evita preguntar "¿tiene semilla?".
object sinSemilla {
    method aplicarEn(cruz) {}
    // Un ícono transparente: con las manos vacías no se dibuja nada
    method imagenEnMano() = assetsManager.manoVacia()
}
