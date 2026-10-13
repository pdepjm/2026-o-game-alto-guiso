import utils.manager.*
import juego.escalaTablero.*

object arriba {
    method siguiente(posicion) = posicion.up(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.up(1)
    method imagenJardinero() = assetsManager.jardineroArriba()
    method girarDerecha() = derecha
    method girarIzquierda() = izquierda
    method esVertical() = true
    method opuesta() = abajo
}

object abajo {
    method siguiente(posicion) = posicion.down(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.down(1)
    method imagenJardinero() = assetsManager.jardineroAbajo()
    method girarDerecha() = izquierda
    method girarIzquierda() = derecha
    method esVertical() = true
    method opuesta() = arriba
}

object izquierda {
    method siguiente(posicion) = posicion.left(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.left(1)
    method imagenJardinero() = assetsManager.jardineroIzquierda()
    method girarDerecha() = arriba
    method girarIzquierda() = abajo
    method esVertical() = false
    method opuesta() = derecha
}

object derecha {
    method siguiente(posicion) = posicion.right(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.right(1)
    method imagenJardinero() = assetsManager.jardineroDerecha()
    method girarDerecha() = abajo
    method girarIzquierda() = arriba
    method esVertical() = false
    method opuesta() = izquierda
}

object giroDerecha {
    method aplicar(direccion) = direccion.girarDerecha()
    method imagen() = assetsManager.rampaArribaDerecha()
}

object giroIzquierda {
    method aplicar(direccion) = direccion.girarIzquierda()
    method imagen() = assetsManager.rampaArribaIzquierda()
}

object giroIzquierdaSuperiorDerecha {
    method aplicar(direccion) = giroIzquierda.aplicar(direccion)
    method imagen() = assetsManager.rampaArribaDerecha()
}

object giroIzquierdaInferiorDerecha {
    method aplicar(direccion) = giroIzquierda.aplicar(direccion)
    method imagen() = assetsManager.rampaAbajoDerecha()
}
