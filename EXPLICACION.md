# Explicación del juego

## 1. Qué es el juego

**Flor de Quilombo** es un juego hecho en Wollok en el que un jardinero debe recorrer un jardín y convertir todas las cruces de colores en flores.

El jugador tiene que:

1. Elegir un nivel desde el menú.
2. Mover al jardinero con las flechas.
3. Recoger semillas de colores.
4. Llevar cada semilla hasta una cruz del mismo color.
5. Repetir el proceso hasta florecer todas las cruces.

El jardinero se mueve deslizándose. Cuando se presiona una flecha, se anima de forma continua entre celdas hasta encontrar una cerca o una piedra. Al pisar una esquina, gira en el sentido configurado; si ese giro apunta contra un muro, rebota en sentido contrario y sigue deslizándose. Mientras está deslizándose, las nuevas teclas de movimiento se ignoran. Esto hace que cada movimiento sea un recorrido completo de extremo a extremo, en lugar de un movimiento de una sola celda.

Una semilla no desaparece al ser recogida: el jardinero la guarda en la mano, pero el objeto sigue en el tablero. Si se recoge otra semilla, reemplaza a la anterior. Una cruz solo florece cuando recibe una semilla del mismo color. Las cruces de otro color, o una cruz visitada sin semilla, no cambian.

El nivel se gana cuando todas sus cruces están florecidas. En ese momento el jardinero se frena y aparece el mensaje `¡Jardín completo! V para volver`.

## 2. Cómo se inicia el juego

La ejecución comienza en el objeto `main`, ubicado en `main.wlk`.

El método `main.iniciar()` realiza estas tareas:

1. Configura el tamaño del tablero: 21 celdas de ancho por 12 de alto.
2. Define el tamaño visual de cada celda: 80 píxeles.
3. Define el título de la ventana.
4. Coloca el fondo de césped.
5. Muestra el menú principal mediante `navegador.iniciar()`.
6. Registra todas las teclas mediante `entradaTeclado.entradasDelTeclado()`.
7. Llama a `game.start()` para comenzar el juego.

`main` es un objeto, no un programa, así que no se puede ejecutar solo. El programa está en
`florDeQuilombo.wpgm`, que lo único que hace es llamar a `main.iniciar()`. En VS Code se ejecuta con el botón
**Run program** que aparece arriba de `program florDeQuilombo`. Desde la consola:

```text
wollok run florDeQuilombo.florDeQuilombo
```

El tablero usa cuatro subceldas por celda lógica y reduce el tamaño de celda visual en la misma proporción,
para conservar el tamaño de ventana mientras permite mover al jardinero en pasos menores.

## 3. Flujo general de una partida

### 3.1 Menú principal

Al comenzar, `navegador.actual` vale `menuPrincipal`. El menú muestra:

- El fondo del menú.
- El botón de jugar.
- El botón de configuración.
- El botón de salir.

La tecla `J` llama a `menuPrincipal.presionarJugar()`. Ese método le pide al `navegador` que cambie a `selectorDeNiveles`.

La configuración todavía no tiene una acción asociada. La tecla `Q` detiene el juego directamente con `game.stop()`.

### 3.2 Selección de nivel

La pantalla `selectorDeNiveles` muestra los botones de los niveles disponibles. Las teclas `1`, `2` y `3` seleccionan sus mapas correspondientes.

Cuando se presiona un número:

1. `entradaTeclado` informa el número a la pantalla actual.
2. `selectorDeNiveles.presionarNivel(numero)` busca el mapa correspondiente en la lista `mapas`.
3. `partida.nivel(...)` guarda ese mapa como el nivel actual.
4. `navegador.irA(partida)` oculta la pantalla de niveles y muestra la partida.

La tecla `V` vuelve al menú principal desde la selección de niveles.

### 3.3 Armado del nivel

Al mostrar `partida`, se ejecuta `partida.armar()`.

El mapa es una lista de strings. Cada carácter representa algo:

| Carácter | Significado |
| --- | --- |
| `#` | Cerca |
| `J` | Posición inicial del jardinero |
| `R` | Semilla roja |
| `A` | Semilla azul |
| `M` | Semilla amarilla |
| `r` | Cruz roja |
| `a` | Cruz azul |
| `m` | Cruz amarilla |
| `D` | Esquina transitable que gira al jardinero a la derecha |
| `I` | Esquina transitable que gira al jardinero a la izquierda |
| `T` | Esquina superior derecha que gira a la izquierda |
| `O` | Esquina inferior derecha que gira a la izquierda |
| Espacio | Celda libre |

`partida.armar()` calcula el tamaño del mapa, lo centra dentro del tablero y recorre cada fila y columna. Para cada carácter llama a `ubicar(letra, posicion)`, que decide qué objeto debe configurarse en esa celda.

Por cada carácter se crea el elemento que corresponde con `new`: `new Valla(...)` para un `#`, `new Cruz(...)` para una cruz, `new Piedra(...)` o `new CharcoDeBarro(...)` para los obstáculos, y `new Esquina(...)` para una esquina. Las semillas no se crean: ya existen las tres y solo se les cambia la posición.

Todo lo que se pone en el tablero va a una única lista, `elementosDelNivel`. Las cruces además se guardan aparte en la lista `cruces`, que es la que se mira para saber si ya está todo plantado.

Después del armado, `partida.mostrar()` agrega a la pantalla todos los elementos de esa lista y, al final, el jardinero y la bolsa de semillas, que se dibuja fuera del mapa.

### 3.4 Movimiento del jardinero

Cuando se presiona una flecha, `entradaTeclado` envía una dirección a la pantalla actual. La pantalla de partida llama a `jardinero.mover(direccion)`.

Si el jardinero no está deslizándose:

1. Guarda la nueva dirección.
2. Marca `deslizando = true`.
3. Registra un evento periódico con `game.onTick`.

El juego representa cada celda lógica con cuatro subceldas de renderizado. Cada ejecución de
`jardinero.animarPaso()` avanza una subcelda entera; al completar cuatro, procesa semillas, esquinas,
cruces y victoria. El motor redondea las posiciones a celdas enteras, por eso esta subdivisión permite
que el jardinero se vea avanzar en pasos más cortos y no saltar una celda completa cada vez.

Antes de comenzar a moverse hacia una nueva celda, consulta a `partida.puedeEntrarA(...)`. Si esa celda
está bloqueada, llama a `jardinero.frenar()`. Si pisa una esquina, aplica el giro; cuando el giro apunta
contra un muro, invierte el rumbo para rebotar y seguir avanzando.

Frenar cambia `deslizando` a `false` y elimina el evento periódico. Así el jardinero puede recibir una nueva dirección.

### 3.5 Interacción con semillas y cruces

Los elementos del tablero no necesitan que el jardinero conozca su tipo concreto. Cada uno responde al mensaje `pisadoPor(jardinero)`.

- Una semilla llama a `jardinero.recoger(self)`.
- Una cruz llama a `jardinero.plantarEn(self)`.

El jardinero guarda una referencia a la semilla actual. Al plantar, delega en esa semilla el método `aplicarEn(cruz)`. La semilla le envía `recibir(self)` a la cruz. La cruz compara la semilla recibida con la semilla que necesita y solo se florece si coinciden.

Este diseño permite que las tres semillas compartan el mismo conjunto de mensajes aunque cada una tenga imágenes y letras distintas.

### 3.6 Finalización y reinicio

Después de cada paso, `partida.verificarSiTermino()` comprueba si todas las cruces cumplen `florecida()`.

Si todas están florecidas y el nivel todavía no estaba ganado:

1. Se marca `ganado = true`.
2. Se frena al jardinero.
3. Se muestra el mensaje de victoria.

Una vez ganado el nivel, `partida.presionarDireccion(...)` ya no permite iniciar nuevos movimientos.

La tecla `R` llama a `partida.presionarReiniciar()`. El nivel se oculta y se muestra de nuevo, por lo que se vacían y vuelven a construir sus elementos desde el mapa original.

La tecla `V` vuelve a la selección de niveles.

## 4. Archivo por archivo

### `main.wlk`

Contiene el objeto `main`, que es el punto de entrada del juego.

Su método `iniciar()` configura el tablero, el título, el fondo, la pantalla inicial, las entradas del teclado y el arranque de Wollok. No contiene reglas del juego: solo prepara el entorno y conecta los componentes principales.

### `juego/cruces.wlk`

Define la clase `Cruz`. Cada instancia tiene:

- Una posición.
- La semilla que le corresponde.
- Un estado que indica si ya floreció.
- Una imagen que cambia según ese estado.
- El comportamiento para reaccionar cuando el jardinero la pisa.

`partida` crea una cruz por cada `r`, `a` o `m` del mapa con `new Cruz(...)`. Antes había seis objetos repetidos (`cruz1` a `cruz6`) y un límite de seis cruces por nivel: con la clase, ese límite desapareció.

### `juego/bloques.wlk`

Define los elementos del jardín que no son ni semillas ni cruces, como clases:

- `Valla`: la cerca que rodea el jardín y arma el laberinto. Bloquea el paso.
- `Piedra`: bloquea el paso igual que una valla, pero en el medio del jardín.
- `CharcoDeBarro`: se puede pisar, pero al hacerlo el jardinero pierde la semilla que llevaba en la mano.
- `Esquina`: se puede pisar y cambia la dirección del jardinero. El sentido del giro y la orientación de la imagen se configuran por separado para que coincidan con la esquina del mapa.

Todas entienden los mismos mensajes que el resto de los elementos (`position()`, `image()`, `esTraspasable()` y `pisadoPor(jardinero)`), así que el jardinero las trata igual que a todo lo demás.

Están juntas en un mismo archivo porque cumplen el mismo papel dentro del tablero: la valla y la piedra se diferencian solo en dónde aparecen, y el charco comparte con ellas el mismo contrato.

Antes de usar clases, las vallas eran sesenta objetos repetidos (`valla1` a `valla60`) y ningún mapa podía tener más de sesenta `#`. La piedra y el charco se colocan con las letras `P` y `B`, que todavía no se usan en los niveles porque faltan sus imágenes.

### `juego/direcciones.wlk`

Define las cuatro direcciones del juego:

- `arriba`
- `abajo`
- `izquierda`
- `derecha`

Cada dirección sabe dos cosas:

1. Cómo calcular la celda siguiente a partir de una posición.
2. Qué imagen debe mostrar el jardinero mientras avanza en esa dirección.
3. Cómo girar a derecha e izquierda.
4. Cómo avanzar una subcelda para animar el movimiento.

Esto evita llenar `jardinero` de condiciones distintas para cada flecha.

### `niveles/mapa1.wlk`

Define el objeto `mapa1`, que representa el primer nivel.

El método `mapa()` devuelve una lista de strings. El contenido textual funciona como un plano del nivel: las posiciones de las letras y de los `#` determinan dónde aparecen las entidades y las cercas.

Un mapa no tiene ninguna lógica: es solo el dibujo. Todo lo que hay que hacer con él lo resuelve `partida`.

`niveles/mapa2.wlk` y `niveles/mapa3.wlk` siguen exactamente el mismo contrato: también ofrecen `mapa()`, pero describen otros tableros. Gracias a que los tres entienden el mismo mensaje, `partida` los usa sin saber cuál le toca.

### `juego/partida.wlk`

Es el módulo central de la lógica de una partida.

Sus responsabilidades son:

- Guardar el nivel elegido.
- Interpretar el mapa.
- Centrar el mapa en el tablero.
- Crear los elementos del nivel (vallas, cruces, piedras y charcos) y ubicar las semillas.
- Determinar si una posición es transitable, preguntándole a los elementos que están ahí.
- Encontrar los elementos de una celda.
- Mostrar y ocultar los objetos visuales.
- Comprobar la victoria.
- Gestionar reinicio y vuelta a la pantalla anterior.

### `juego/jardinero.wlk`

Define el objeto `jardinero`.

Guarda:

- Su posición.
- Su dirección actual.
- La semilla que tiene en la mano.
- Si está deslizándose.

Sus métodos principales son:

- `empezarEn(posicionInicial)`: reinicia su estado en una posición del mapa.
- `mover(direccion)`: inicia un deslizamiento si no hay otro en curso.
- `animarPaso()`: mueve al jardinero una subcelda por tick para suavizar el recorrido.
- `avanzarUnPaso()`: calcula y ejecuta un paso lógico completo.
- `frenar()`: detiene el evento de movimiento.
- `recoger(semilla)`: cambia la semilla que lleva.
- `plantarEn(cruz)`: delega en la semilla la interacción con una cruz.
- `girar(giro)`: aplica el giro de la esquina o rebota si el rumbo está bloqueado.

La imagen del jardinero se obtiene de la dirección actual, por lo que cambia automáticamente al moverse.

El objeto `bolsaDeSemillas` muestra, fuera del mapa, un saco vacío o el saco del color de la semilla que lleva el jardinero. Su imagen consulta el estado actual, así que se actualiza al recoger una semilla o perderla en el barro. `partida` lo agrega y lo quita junto con los demás elementos visuales.

### `juego/semillas.wlk`

Define la clase `Semilla` y sus tres instancias: `semillaRoja`, `semillaAzul` y `semillaAmarilla`. Las tres se comportan igual, así que el comportamiento está escrito una sola vez en la clase y cada instancia solo cambia sus valores.

Cada una conoce:

- La letra que la representa en el mapa.
- La letra de su cruz correspondiente.
- La imagen de la semilla.
- La imagen de la cruz.
- La imagen de la flor.

Todas implementan los mismos métodos, aunque devuelven datos diferentes según el color. También define `sinSemilla`, que representa la mano vacía del jardinero y no produce ninguna acción al intentar plantar.

### `pantallas/menuPrincipal.wlk`

Define el objeto `fondoMenu`, que tapa el césped, y el objeto `menuPrincipal`, que es la pantalla.

Los tres botones (jugar, configuración y salir) son instancias de la clase `Boton` (`pantallas/boton.wlk`) y viven en una lista adentro de la pantalla. `menuPrincipal.mostrar()` recorre esa lista y los agrega al juego; `ocultar()` los quita.

El botón de jugar cambia a la pantalla de niveles. Las acciones de configuración, volver, selección de nivel, dirección y reinicio están vacías en este menú porque no corresponden a esta pantalla.

### `pantallas/selectorDeNiveles.wlk`

Define la pantalla de selección de niveles.

Contiene el objeto `selectorDeNiveles`, que administra la pantalla completa, con botones para los tres niveles y volver, como instancias de `Boton`.

La lista `mapas` mantiene la relación entre el número elegido y el mapa que debe cargarse. `presionarNivel(numero)` obtiene el mapa correspondiente, lo guarda en `partida` y navega hacia la partida.

### `pantallas/navegador.wlk`

Centraliza la navegación entre pantallas.

La variable `actual` guarda el objeto que representa la pantalla visible. Todos los objetos de pantalla tienen métodos compatibles, como `mostrar()`, `ocultar()`, `presionarJugar()` y `presionarVolver()`, aunque algunos métodos quedan vacíos según la pantalla.

`irA(pantalla)` siempre hace tres pasos:

1. Oculta la pantalla actual.
2. Actualiza la variable `actual`.
3. Muestra la nueva pantalla.

Gracias a esto, el teclado puede enviar mensajes a `navegador.actual()` sin conocer de antemano si está hablando con el menú, el selector o la partida.

### `utils/io.wlk`

Define `entradaTeclado`, que conecta teclas con acciones del juego.

Las teclas no modifican directamente al jardinero ni a las pantallas. En cambio, envían mensajes a la pantalla actual:

| Tecla | Mensaje |
| --- | --- |
| `J` | `presionarJugar()` |
| `V` | `presionarVolver()` |
| `R` | `presionarReiniciar()` |
| `1`, `2` y `3` | `presionarNivel(numero)` |
| Flecha arriba | `presionarDireccion(arriba)` |
| Flecha abajo | `presionarDireccion(abajo)` |
| Flecha izquierda | `presionarDireccion(izquierda)` |
| Flecha derecha | `presionarDireccion(derecha)` |
| `Q` | Detener el juego |

La tecla `C` está registrada, pero todavía no tiene comportamiento.

### `utils/manager.wlk`

Define `assetsManager`, un único lugar desde el que se obtienen los nombres de las imágenes.

Contiene métodos para:

- Fondos.
- Botones del menú y de selección de niveles.
- Imágenes del jardinero.
- Semillas y sacos (vacío o del color que lleva el jardinero).
- Cruces.
- Flores.
- Cercas.

Centralizar los nombres de los assets permite cambiar una imagen sin tener que buscar su nombre en toda la lógica del juego.

### `tests/jardinero.wtest`

Prueba el movimiento y las reglas principales del jardinero usando un mapa pequeño creado dentro del test.

Comprueba que:

- El jardinero se desliza hasta una cerca.
- Recoge semillas.
- No planta sin semilla.
- Planta una cruz del mismo color.
- No planta una cruz de otro color.
- Una semilla nueva reemplaza a la anterior.
- La semilla permanece en el tablero.
- La victoria ocurre solo después de plantar todas las cruces.
- El jardinero deja de moverse al ganar.
- Reiniciar devuelve el nivel a su estado inicial.

El método `deslizar(direccion)` simula manualmente varios pasos porque los eventos `onTick` no avanzan automáticamente durante los tests.

El mismo archivo tiene un segundo `describe`, con otro mapa de prueba, para los obstáculos:

- La piedra frena al jardinero igual que una cerca.
- El charco de barro le arruina la semilla que llevaba.
- El charco no lo frena.
- Las esquinas derecha e izquierda cambian el rumbo sin detener el deslizamiento.

### `tests/navegacion.wtest`

Prueba la navegación entre el menú principal, el selector de niveles y la partida.

Comprueba que:

- El juego comienza en el menú.
- `J` lleva al selector.
- Las flechas no mueven al jardinero desde el menú.
- Se puede elegir el nivel 2.
- `V` vuelve desde una partida al selector.
- `V` vuelve desde el selector al menú.
- Cada mapa crea la cantidad esperada de cruces.

### `README.md`

Es la guía breve del proyecto. Contiene los nombres del equipo, una descripción resumida del juego, los controles, el comando de ejecución y el formato de los mapas.

Este archivo sirve como referencia rápida. Este documento (`EXPLICACION.md`) desarrolla con más detalle la arquitectura y el funcionamiento interno.

### `package.json`

Contiene la información básica del proyecto Wollok:

- Nombre del proyecto.
- Versión.
- Carpeta de recursos.
- Versión de Wollok.
- Autor.
- Licencia.

No contiene la lógica del juego.

## 5. Carpeta `assets`

Contiene las imágenes utilizadas por los objetos del juego, agrupadas en subcarpetas: `Fondos`, `UI`, `Jardinero`, `Semillas`, `Cruces`, `Flores` y `Cercas`.

Los archivos de código no dibujan estas imágenes directamente: piden su nombre a `assetsManager`. El nombre incluye la subcarpeta, por ejemplo `"Semillas/red_seed.png"`. Como `assetsManager` es el único que conoce esos nombres, mover una imagen de carpeta se arregla tocando un solo archivo.

## 6. Relación entre los módulos

La relación principal puede resumirse así:

```text
florDeQuilombo.wpgm
└── llama a main.iniciar()

main
├── configura game
├── inicia el navegador
└── registra entradaTeclado

entradaTeclado
└── envía mensajes a navegador.actual()

navegador
├── menuPrincipal
├── selectorDeNiveles
└── partida

partida
├── interpreta mapa1, mapa2 o mapa3
├── configura jardinero
├── configura semillas
├── configura cruces
├── configura vallas
└── controla la victoria

jardinero
├── usa direcciones
├── consulta las reglas de partida
└── interactúa con semillas y cruces
```

La idea más importante es que cada módulo tenga una responsabilidad concreta: los mapas describen datos, las semillas y cruces resuelven sus propias interacciones, `partida` administra el tablero, `jardinero` administra el movimiento, las pantallas administran la navegación y `entradaTeclado` conecta el teclado con esas acciones.
