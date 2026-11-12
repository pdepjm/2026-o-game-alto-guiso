import utils.manager.*
import juego.escalaTablero.*

// Las cuatro direcciones en las que se puede mover el jardinero. Cada una sabe cómo
// avanzar, qué imagen le corresponde al jardinero y en qué se convierte al rebotar
// contra cada una de las dos diagonales posibles de una esquina.

object arriba {
    method siguiente(posicion) = posicion.up(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.up(1)
    method imagenJardinero() = assetsManager.jardineroArriba()
    method esVertical() = true
    method opuesta() = abajo
    method reflejadaEnCreciente() = derecha
    method reflejadaEnDecreciente() = izquierda
}

object abajo {
    method siguiente(posicion) = posicion.down(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.down(1)
    method imagenJardinero() = assetsManager.jardineroAbajo()
    method esVertical() = true
    method opuesta() = arriba
    method reflejadaEnCreciente() = izquierda
    method reflejadaEnDecreciente() = derecha
}

object izquierda {
    method siguiente(posicion) = posicion.left(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.left(1)
    method imagenJardinero() = assetsManager.jardineroIzquierda()
    method esVertical() = false
    method opuesta() = derecha
    method reflejadaEnCreciente() = abajo
    method reflejadaEnDecreciente() = arriba
}

object derecha {
    method siguiente(posicion) = posicion.right(escalaTablero.factor())
    method siguienteSubcelda(posicion) = posicion.right(1)
    method imagenJardinero() = assetsManager.jardineroDerecha()
    method esVertical() = false
    method opuesta() = izquierda
    method reflejadaEnCreciente() = arriba
    method reflejadaEnDecreciente() = abajo
}

// Una esquina desvía al jardinero como lo haría un espejo puesto en su diagonal: hacia
// dónde sale depende de por dónde entró, no es un giro fijo a izquierda o a derecha.
// Por eso hay solo dos diagonales posibles, y las cuatro maderas de esquina se reparten
// entre ellas según qué mitad de la celda ocupan.
//
// Cada diagonal no resuelve el rebote por su cuenta: se lo pregunta a la dirección,
// que es la que sabe en qué se convierte. Así no hace falta ningún if.

// La diagonal que sube hacia la derecha, "/". Intercambia derecha con arriba
// e izquierda con abajo.
object diagonalCreciente {
    method cambiar(direccion) = direccion.reflejadaEnCreciente()
}

// La diagonal que baja hacia la derecha, "\". Intercambia derecha con abajo
// e izquierda con arriba.
object diagonalDecreciente {
    method cambiar(direccion) = direccion.reflejadaEnDecreciente()
}
