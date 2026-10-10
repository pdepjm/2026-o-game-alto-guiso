import wollok.game.*
import utils.manager.*

// Las tres semillas hacen exactamente lo mismo: lo único que cambia son sus letras
// en el mapa y sus imágenes. Por eso son instancias de una misma clase y no tres
// objetos con el código repetido.
class Semilla {
    const property letra
    const property letraCruz
    const property image
    const property imagenCruz
    const property imagenFlor
    const property imagenEnMano
    var property position = game.origin()

    // El jardinero la levanta al pasar por encima
    method pisadoPor(jardinero) { jardinero.recoger(self) }

    // Plantarse es cosa de la semilla: la cruz después decide si es de su color
    method aplicarEn(cruz) { cruz.recibir(self) }

    method esTraspasable() = true
}

const semillaRoja = new Semilla(
    letra = "R",
    letraCruz = "r",
    image = assetsManager.semillaRoja(),
    imagenCruz = assetsManager.cruzRoja(),
    imagenFlor = assetsManager.florRoja(),
    imagenEnMano = assetsManager.manoRoja()
)

const semillaAzul = new Semilla(
    letra = "A",
    letraCruz = "a",
    image = assetsManager.semillaAzul(),
    imagenCruz = assetsManager.cruzAzul(),
    imagenFlor = assetsManager.florAzul(),
    imagenEnMano = assetsManager.manoAzul()
)

const semillaAmarilla = new Semilla(
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
