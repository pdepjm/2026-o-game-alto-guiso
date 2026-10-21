import wollok.game.*
import utils.manager.*
import juego.bloques.*

// Las tres semillas hacen exactamente lo mismo: lo único que cambia son sus letras
// en el mapa y sus imágenes. Por eso son instancias de una misma clase y no tres
// objetos con el código repetido.

// Superclase abstracta. Al heredar de Bloque, gana automaticamente la variable 'position' y el metodo 'esTraspasable() = true'
class Semilla inherits Bloque {

    // El jardinero la levanta al pasar por encima
    override method pisadoPor(jardinero) { 
        jardinero.recoger(self)
    }

    // Plantarse es cosa de la semilla: la cruz después decide si es de su color
    method aplicarEn(cruz) { 
        cruz.recibir(self) 
    }

    method letra()
    method letraCruz()
    method image()
    method imagenCruz()
    method imagenFlor()
    method imagenEnMano()
}

class semillaRoja inherits Semilla {
    override method image() = assetsManager.semillaRoja()
    override method letra() = "R"
    override method letraCruz() = "r"
    override method imagenCruz() = assetsManager.cruzRoja()
    override method imagenFlor() = assetsManager.florRoja()
    override method imagenEnMano() = assetsManager.manoRoja()
}

class SemillaAzul inherits Semilla {
    override method image() = assetsManager.semillaAzul()
    override method letra() = "A"
    override method letraCruz() = "a"
    override method imagenCruz() = assetsManager.cruzAzul()
    override method imagenFlor() = assetsManager.florAzul()
    override method imagenEnMano() = assetsManager.manoAzul()
}

class SemillaAmarilla inherits Semilla {
    override method image() = assetsManager.semillaAmarilla()
    override method letra() = "M"
    override method letraCruz() = "m"
    override method imagenCruz() = assetsManager.cruzAmarilla()
    override method imagenFlor() = assetsManager.florAmarilla()
    override method imagenEnMano() = assetsManager.manoAmarilla()
}

// La mano vacía del jardinero. Es un concepto único en el juego, así que es un objeto
// y no una clase. Al no hacer nada en aplicarEn, nos evita preguntar "¿tiene semilla?".
object sinSemilla {
    method aplicarEn(cruz) {}
    // Un ícono transparente: con las manos vacías no se dibuja nada
    method imagenEnMano() = assetsManager.manoVacia()
}
