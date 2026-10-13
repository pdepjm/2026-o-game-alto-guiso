// Único lugar donde están los nombres de las imágenes.
// El nombre incluye la subcarpeta dentro de assets, por ejemplo "Semillas/red_seed.png".
object assetsManager {
    method fondoMenu() = "Fondos/fondoMenu1.png"
    method fondoCesped() = "Fondos/grass.png"
    method botonJugar() = "UI/boton_jugar.png"
    method botonConfiguracion() = "UI/boton_configuracion.png"
    method botonSalir() = "UI/boton_salir.png"
    method botonVolver() = "UI/boton_volver.png"

    // El cartel de cada nivel, y el gris con candado para los que todavía no se desbloquearon
    method botonDeNivel(numero) = "UI/boton_nivel" + numero + ".png"
    method botonBloqueado(numero) = "UI/boton_nivel" + numero + "_bloqueado.png"
    method cartelVictoria() = "UI/cartel_victoria.png"
    method tituloDelJuego() = "UI/titulo.png"

    // Las teclas de cada pantalla y el cronometro vienen con el texto dibujado adentro,
    // porque el motor del juego no deja agrandar los textos (los dibuja siempre en 12 px)
    method teclasDelMenu() = "UI/teclas_menu.png"
    method teclasDelSelector() = "UI/teclas_selector.png"
    method teclasDeLaPartida() = "UI/teclas_partida.png"
    method etiquetaTiempo() = "UI/etiqueta_tiempo.png"
    method digito(numero) = "UI/digito_" + numero + ".png"
    method digitoVacio() = "UI/digito_vacio.png"
    method medalla(nota) = "UI/medalla_" + nota + ".png"

    method jardineroAbajo() = "Jardinero/player_down.png"
    method jardineroArriba() = "Jardinero/player_up.png"
    method jardineroDerecha() = "Jardinero/player_rigth.png"
    method jardineroIzquierda() = "Jardinero/player_left.png"
    method esquinaDerecha() = "Cercas/corner_sup_rigth.png"
    method esquinaIzquierda() = "Cercas/corner_sup_left.png"
    method esquinaInferiorDerecha() = "Cercas/corner_inf_rigth.png"

    // El ícono de la semilla que lleva en la mano
    method manoRoja() = "Jardinero/mano_roja.png"
    method manoAzul() = "Jardinero/mano_azul.png"
    method manoAmarilla() = "Jardinero/mano_amarilla.png"
    method manoVacia() = "Jardinero/mano_vacia.png"

    method semillaRoja() = "Semillas/red_seed.png"
    method semillaAzul() = "Semillas/blue_seed.png"
    method semillaAmarilla() = "Semillas/yellow_seed.png"
    method cruzRoja() = "Cruces/red_x.png"
    method cruzAzul() = "Cruces/blue_x.png"
    method cruzAmarilla() = "Cruces/yellow_x.png"
    method florRoja() = "Flores/red_flower.png"
    method florAzul() = "Flores/blue_flower.png"
    method florAmarilla() = "Flores/yellow_flower.png"
    method valla() = "Cercas/fence_x1.png"

    // Todavía no están dibujadas: hay que agregar los dos .png en assets/Obstaculos/
    method piedra() = "Obstaculos/piedra.png"
    method barro() = "Obstaculos/barro.png"
}
