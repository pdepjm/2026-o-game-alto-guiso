### Flor de Quilombo

* Sofia Bravo
* Lucia salinas
* Nicolas Becco
* Joaquin Zimerman
* Tobias Charap

#### El juego

Un jardinero recorre el jardín para plantar flores. Una vez que arranca en una dirección no frena hasta
chocar contra una cerca o una piedra. Las esquinas funcionan como un espejo puesto en su diagonal: hacia
dónde sale el jardinero depende de por dónde entró, así que la misma esquina lo manda para dos lados
distintos. Si el paso de salida está bloqueado, se detiene en la esquina. El movimiento entre celdas
es animado. Tiene que recoger las semillas de colores y pasar por las cruces del mismo color: al pasar,
la cruz se convierte en la flor de ese color. Se gana cuando todas las cruces tienen su flor.

- Agarrar una semilla reemplaza la que tenía en la mano (la bolsa de semillas queda en su lugar).
  Un ícono del color de la semilla se dibuja sobre el jardinero para saber qué lleva.
- Pasar por una cruz de otro color, o sin semilla, no hace nada.
- Hay cinco niveles. Al empezar solo está desbloqueado el nivel 1, y cada nivel completado
  desbloquea el siguiente.
- Al completar un nivel, se puede continuar con `N` si hay un nivel siguiente.
- La opción `C` del menú abre la pantalla de configuración; `V` vuelve al menú.
- Desde configuración se ajusta el volumen general con `J`/`C` y el ambiental con `R`/`N`;
  `1` silencia o activa todo el audio y `2` silencia o activa solo el sonido de parque.
- El volumen general controla los efectos y el ambiente; el nivel ambiental se regula aparte.
- Un cronómetro cuenta lo que tarda cada nivel y al terminar da una nota de S a D, según el
  tiempo ideal que define cada nivel.
- Abajo de todo siempre se ven las teclas que se pueden apretar en esa pantalla.
- También se puede perder: las espinas y el vidrio ya rajado matan al jardinero. Aparece un cartel
  y con `R` se reintenta el nivel.
- La primera vez que el jardinero pisa el vidrio, este se raja y suena un efecto de hielo quebrándose.

#### Controles

| Tecla | Acción |
|---|---|
| J | Jugar (desde el menú) |
| C | Abrir configuración (desde el menú) |
| J / C | Bajar / subir el volumen general (en configuración) |
| R / N | Bajar / subir el volumen ambiental (en configuración) |
| 1 / 2 | Silenciar todo / solo el ambiente (en configuración) |
| 1 a 5 | Elegir nivel |
| N | Siguiente nivel (al completar un nivel) |
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

Cada nivel es una instancia de la clase `Nivel` (`niveles/nivel.wlk`) que vive en `niveles/`. Sabe su
número, cuántos segundos se consideran una vuelta perfecta y su `mapa`, que es un dibujo hecho con
texto. Un nivel no sabe si está desbloqueado: de eso lleva la cuenta el selector, con una lista que
empieza con el nivel 1 y le va sumando los que se completan.

| Letra | Qué es |
|---|---|
| `#` | cerca |
| `J` | donde empieza el jardinero |
| `R` `A` `M` | semilla roja, azul, amarilla |
| `r` `a` `m` | cruz roja, azul, amarilla |
| `P` | piedra (bloquea el paso) |
| `B` | charco de barro (se puede pisar, pero arruina la semilla) |
| `X` | espinas (al pisarlas se pierde el nivel) |
| `E` | escalera (frena el deslizamiento; parado en ella se sube y se baja de a un escalón, y al salir de la última sigue de largo) |
| `H` | agujero de topo (se entra por uno y se sale por el otro) |
| `V` | piso de vidrio (aguanta una sola pasada: queda rajado y a la segunda se cae) |
| `I` | esquina arriba-izquierda |
| `D` | esquina arriba-derecha |
| `T` | esquina abajo-izquierda |
| `O` | esquina abajo-derecha |

Todo lo que se pone en el tablero es una instancia de su clase, así que un mapa puede tener todas las
que haga falta. Los agujeros de topo se emparejan **de a dos, en el orden en que aparecen en el mapa**:
el primero con el segundo, el tercero con el cuarto.

Un nivel nuevo se agrega creando su archivo en `niveles/`, sumándolo a la lista `niveles` de
`pantallas/selectorDeNiveles.wlk` con su botón, y registrando su tecla en `utils/io.wlk`.

Cuidado al dibujar un mapa: como el jardinero se desliza hasta chocar, es fácil armar un nivel que no se
pueda ganar. Los niveles 4 y 5 tienen un test que los juega entero con la secuencia de flechas de la
solución, justamente para que eso no pase desapercibido.
