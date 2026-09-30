### Flor de Quilombo

* Sofia Bravo
* Lucia salinas
* Nicolas Becco
* Joaquin Zimerman
* Tobias Charap

#### El juego

Un jardinero recorre el jardín para plantar flores. Una vez que arranca en una dirección no frena hasta
chocar contra una cerca. Tiene que recoger las semillas de colores y pasar por las cruces del mismo color:
al pasar, la cruz se convierte en la flor de ese color. Se gana cuando todas las cruces tienen su flor.

- Agarrar una semilla reemplaza la que tenía en la mano (la bolsa de semillas queda en su lugar).
- Pasar por una cruz de otro color, o sin semilla, no hace nada.

#### Controles

| Tecla | Acción |
|---|---|
| J | Jugar (desde el menú) |
| 1, 2 | Elegir nivel |
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

Las cercas, las cruces, las piedras y los charcos son instancias de sus clases, así que un mapa
puede tener todas las que haga falta. La `P` y la `B` funcionan, pero todavía no tienen imagen
(`assets/Obstaculos/piedra.png` y `barro.png`), así que por ahora no se usan en los niveles.
