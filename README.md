### Flor de Quilombo

* Sofia Bravo
* Lucia salinas
* Nicolas Becco
* Joaquin Zimerman
* Tobias Charap

#### El juego

Un jardinero recorre el jardín para plantar flores. Una vez que arranca en una dirección no frena hasta
chocar contra una cerca o una piedra. Las esquinas del jardín pueden cambiar su dirección hacia la
derecha o la izquierda; si el giro apunta contra una pared, rebota hacia atrás. El movimiento entre
celdas es animado. Tiene que recoger las semillas de colores y pasar por las cruces del mismo color:
al pasar, la cruz se convierte en la flor de ese color. Se gana cuando todas las cruces tienen su flor.

- Agarrar una semilla reemplaza la que tenía en la mano (la bolsa de semillas queda en su lugar).
  Un ícono del color de la semilla se dibuja sobre el jardinero para saber qué lleva.
- Pasar por una cruz de otro color, o sin semilla, no hace nada.
- Al empezar solo está desbloqueado el nivel 1. Cada nivel completado desbloquea el siguiente.
- Un cronómetro cuenta lo que tarda cada nivel y al terminar da una nota de S a D, según el
  tiempo ideal que define cada nivel.
- Abajo de todo siempre se ven las teclas que se pueden apretar en esa pantalla.

#### Controles

| Tecla | Acción |
|---|---|
| J | Jugar (desde el menú) |
| 1, 2, 3 | Elegir nivel |
| Flechas | Mover al jardinero |
| R | Reiniciar el nivel |
| V | Volver |
| Q | Salir |

#### Cómo correrlo

En VS Code, abrir `florDeQuilombo.wpgm` y usar el botón **Run program** que aparece arriba de `program florDeQuilombo`.
Desde la consola es lo mismo:

```
wollok run florDeQuilombo.florDeQuilombo
wollok test
```

#### Agregar o cambiar un nivel

Cada nivel es un objeto en `niveles/` con un `mapa()` dibujado con texto:

| Letra | Qué es |
|---|---|
| `#` | cerca |
| `J` | donde empieza el jardinero |
| `R` `A` `M` | semilla roja, azul, amarilla |
| `r` `a` `m` | cruz roja, azul, amarilla |
| `P` | piedra (bloquea el paso) |
| `B` | charco de barro (se puede pisar, pero arruina la semilla) |
| `D` | esquina que gira a la derecha |
| `I` | esquina que gira a la izquierda |
| `T` | esquina superior derecha que gira a la izquierda |
| `O` | esquina inferior derecha que gira a la izquierda |

Las cercas, las cruces, las piedras, los charcos y las esquinas son instancias de sus clases, así que un mapa
puede tener todas las que haga falta. La `P` y la `B` funcionan, pero todavía no tienen imagen
(`assets/Obstaculos/piedra.png` y `barro.png`), así que por ahora no se usan en los niveles.

El mapa 3 tiene seis cruces y un recorrido circular: las esquinas `T` y `O` desvían al jardinero hacia
la izquierda y continúan el recorrido. El ícono sobre el jardinero cambia según la semilla que lleva.
