// Único lugar donde están los nombres de las imágenes.
// El nombre incluye la subcarpeta dentro de assets, por ejemplo "Semillas/red_seed.png".
object assetsManager {
    method fondoMenu() = "Fondos/fondoMenu1.png"
    method fondoCesped() = "Fondos/grass.png"
    method botonJugar() = "UI/play_botton.png"
    method botonConfiguracion() = "UI/setting_button.png"
    method botonSalir() = "UI/exit_button.png"
    method botonVolver() = "UI/back_button.png"

    // El cartel de cada nivel, y el gris con candado para los que todavía no se desbloquearon
    method botonDeNivel(numero) = "UI/boton_nivel" + numero + ".png"
    method botonBloqueado() = "UI/boton_nivel_bloqueado.png"

    method jardineroAbajo() = "Jardinero/player_down.png"
    method jardineroArriba() = "Jardinero/player_up.png"
    method jardineroDerecha() = "Jardinero/player_rigth.png"
    method jardineroIzquierda() = "Jardinero/player_left.png"
    method esquinaDerecha() = "Cercas/corner_sup_rigth.png"
    method esquinaIzquierda() = "Cercas/corner_sup_left.png"
    method esquinaInferiorDerecha() = "Cercas/corner_inf_rigth.png"

    method semillaRoja() = "Semillas/red_seed.png"
    method semillaAzul() = "Semillas/blue_seed.png"
    method semillaAmarilla() = "Semillas/yellow_seed.png"
    method bolsaVacia() = "Semillas/empty_sack.png"
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
