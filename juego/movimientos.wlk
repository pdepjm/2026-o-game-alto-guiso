// Cómo se está moviendo el jardinero en este momento.
//
// Antes esto eran dos booleanos (`deslizando` y `enEscalera`) y el jardinero tenía que
// combinarlos con ifs para decidir qué hacer con cada flecha. Ahora hay un objeto por
// cada forma de moverse, el jardinero tiene uno y le delega la decisión: cambiar de
// estado es reapuntar esa referencia a otro objeto.
//
// Los tres entienden los mismos mensajes, así que el jardinero los trata igual:
//   mover(jardinero, direccion)  -> qué hacer cuando se aprieta una flecha
//   estaDeslizando()             -> si está en medio de un recorrido
//   estaEnEscalera()             -> si está parado en una escalera

// Parado en el piso: cualquier flecha arranca un recorrido completo hasta chocar.
object enElPiso {
    method mover(jardinero, direccion) { jardinero.empezarADeslizar(direccion) }
    method estaDeslizando() = false
    method estaEnEscalera() = false
}

// Parado en una escalera: las flechas verticales lo suben o lo bajan de a un escalón,
// y las horizontales lo bajan de la escalera y lo devuelven al deslizamiento de siempre.
object enLaEscalera {
    method mover(jardinero, direccion) {
        if (direccion.esVertical()) jardinero.subirUnEscalon(direccion)
        else jardinero.empezarADeslizar(direccion)
    }

    method estaDeslizando() = false
    method estaEnEscalera() = true
}

// En medio de un recorrido: las flechas se ignoran hasta que frene. Eso es lo que hace
// que cada movimiento sea de punta a punta y no de a una celda.
object deslizandose {
    method mover(jardinero, direccion) {}
    method estaDeslizando() = true
    method estaEnEscalera() = false
}
