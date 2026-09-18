import wollok.game.*

object jugador {
    var imagen = "player_down.png"
    var posicionX = 0.0
    var posicionY = 0.0

    method position() = game.at(posicionX, posicionY)

    method image() = imagen

    method imagen() = imagen

    method moverArriba(){
        imagen = "player_down.png"
        self.actualizar()
        game.onTick(0, "mover jugador hacia arriba",{
            posicionY += 2.0
        })
    }

    method moverAbajo(){
        imagen = "player_down.png"
        self.actualizar()
        game.onTick(0, "mover jugador hacia abajo",{ // NO se si esto esta bien jajaj
            posicionY -= 2.0
        })
    }

    method moverDerecha(){
        imagen = "player_down.png"
        self.actualizar()
    }

    method moverIzquierda(){
        imagen = "player_down.png"
        self.actualizar()
    }

    method actualizar(){
        game.removeVisual(self)
        game.addVisual(self)
    }
}