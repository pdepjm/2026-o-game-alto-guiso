import wollok.game.*
import juego.jardinero.*

// Un ícono chiquito que se dibuja encima del jardinero y muestra qué semilla lleva.
// Sigue al jardinero porque su posición es la del jardinero, y su imagen se la pide
// a la semilla que tiene en la mano. Si no lleva nada, la imagen es transparente.
object manoDelJardinero {
    method position() = jardinero.position()
    method image() = jardinero.semillaEnMano().imagenEnMano()
}
