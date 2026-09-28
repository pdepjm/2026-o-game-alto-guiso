import wollok.game.*
import utils.manager.*

// Definimos una clase de Vallas para eliminar la repeticion de codigo y agrupar la lógica
class Valla {
    var property position // Cada valla va a tener su propia ubicación 

    method image() = assetsManager.Valla() // Para que cada valla se pueda mostrar

    // Las vallas bloquean el paso
    method esTraspasable() = false
}