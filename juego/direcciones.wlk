import utils.manager.*

object arriba {
    method siguiente(posicion) = posicion.up(1)
    method imagenJardinero() = assetsManager.jardineroArriba()
}

object abajo {
    method siguiente(posicion) = posicion.down(1)
    method imagenJardinero() = assetsManager.jardineroAbajo()
}

object izquierda {
    method siguiente(posicion) = posicion.left(1)
    method imagenJardinero() = assetsManager.jardineroIzquierda()
}

object derecha {
    method siguiente(posicion) = posicion.right(1)
    method imagenJardinero() = assetsManager.jardineroDerecha()
}
