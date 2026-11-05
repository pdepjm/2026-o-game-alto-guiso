# Explicación del juego

## 1. Qué es el juego

**Flor de Quilombo** es un juego hecho en Wollok en el que un jardinero debe recorrer un jardín y convertir todas las cruces de colores en flores.

El jugador tiene que:

1. Elegir un nivel desde el menú.
2. Mover al jardinero con las flechas.
3. Recoger semillas de colores.
4. Llevar cada semilla hasta una cruz del mismo color.
5. Repetir el proceso hasta florecer todas las cruces.

El jardinero se mueve deslizándose. Cuando se presiona una flecha, se anima de forma continua entre celdas hasta encontrar una cerca o una piedra. Al pisar una esquina, rebota contra su diagonal como contra un espejo: hacia dónde sale depende de por dónde entró, así que la misma esquina lo manda para dos lados distintos. Si el paso de salida está bloqueado, se detiene ahí. Mientras está deslizándose, las nuevas teclas de movimiento se ignoran. Esto hace que cada movimiento sea un recorrido completo de extremo a extremo, en lugar de un movimiento de una sola celda.

Una semilla no desaparece al ser recogida: el jardinero la guarda en la mano, pero el objeto sigue en el tablero. Si se recoge otra semilla, reemplaza a la anterior. Una cruz solo florece cuando recibe una semilla del mismo color. Las cruces de otro color, o una cruz visitada sin semilla, no cambian.

El nivel se gana cuando todas sus cruces están florecidas. En ese momento el jardinero se frena y aparece un cartel con el tiempo que tardó y la nota que se sacó. También se puede perder: las espinas y el piso de vidrio ya rajado matan al jardinero y aparece un cartel de derrota.

Hay cinco niveles. Al abrir el juego solo se puede entrar al primero, y cada nivel completado desbloquea el siguiente.

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
- El título del juego.
- El botón de jugar.
- El botón de configuración.
- El botón de salir.

La tecla `J` llama a `menuPrincipal.presionarJugar()`. Ese método le pide al `navegador` que cambie a `selectorDeNiveles`.

La tecla `C` abre `configuracion`, que permite ajustar los volúmenes con `J`/`C` (general)
y `R`/`N` (ambiente). Las teclas `1` y `2` silencian todo el audio o solo el ambiente,
respectivamente. El objeto `sonidos` aplica el volumen general a los efectos y combina
ese valor con el volumen ambiental para el sonido del parque. La tecla `Q` detiene el juego
directamente con `game.stop()`.

### 3.2 Selección de nivel

La pantalla `selectorDeNiveles` muestra los carteles de los cinco niveles, tres arriba y dos abajo. Las teclas `1` a `5` seleccionan sus mapas correspondientes.

Cuando se presiona un número:

1. `entradaTeclado` informa el número a la pantalla actual.
2. `selectorDeNiveles.presionarNivel(numero)` busca el nivel correspondiente en la lista `niveles`.
3. Si ese nivel está en `nivelesDesbloqueados`, `partida.jugar(...)` lo guarda como nivel actual y navega hacia la partida. Si no está, la pantalla se queda donde está.

El selector inicia `nivelesDesbloqueados` con `mapa1` y agrega el siguiente nivel cuando se completa el actual. Cada nivel compone un objeto de estado (`nivelBloqueado` o `nivelDesbloqueado`), que decide la imagen del botón; no guarda un booleano de desbloqueo.

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
| `P` | Piedra, bloquea el paso |
| `B` | Charco de barro, se puede pisar pero arruina la semilla |
| `X` | Espinas, al pisarlas se pierde el nivel |
| `E` | Escalera, frena el deslizamiento |
| `H` | Agujero de topo, teletransporta al otro agujero |
| `V` | Piso de vidrio, aguanta una sola pasada |
| `I` | Esquina que ocupa la mitad de arriba a la izquierda |
| `D` | Esquina que ocupa la mitad de arriba a la derecha |
| `T` | Esquina que ocupa la mitad de abajo a la izquierda |
| `O` | Esquina que ocupa la mitad de abajo a la derecha |
| Espacio | Celda libre |

`partida.armar()` calcula el tamaño del mapa, lo centra dentro del tablero y recorre cada fila y columna. Para cada carácter llama a `ubicar(letra, posicion)`, que decide qué objeto debe configurarse en esa celda.

Por cada carácter se crea el elemento que corresponde con `new`: `new Valla(...)` para un `#`, `new Cruz(...)` para una cruz, `new Espinas(...)`, `new Escalera(...)`, `new Vidrio(...)` y así con el resto. Las semillas no se crean: ya existen las tres y solo se les cambia la posición.

Los agujeros de topo son el único caso que necesita algo más: se emparejan de a dos en el orden en que aparecen en el mapa. `partida` guarda en `agujerosSinPareja` el que todavía está esperando, y cuando aparece el siguiente los conecta entre sí.

Todo lo que se pone en el tablero va a una única lista, `elementosDelNivel`. Las cruces además se guardan aparte en la lista `cruces`, que es la que se mira para saber si ya está todo plantado.

Después del armado, `partida.mostrar()` agrega a la pantalla todos los elementos de esa lista y, al final, el jardinero con el ícono de la semilla que lleva en la mano. También arranca el cronómetro.

### 3.4 Movimiento del jardinero

Cuando se presiona una flecha, `entradaTeclado` envía una dirección a la pantalla actual. La pantalla de partida llama a `jardinero.mover(direccion)`, siempre que el nivel no esté ya ganado ni perdido.

El jardinero no decide él mismo qué hacer con esa flecha: se lo pregunta a su **estado de movimiento**, que es un objeto. Hay uno por cada forma de moverse y los tres entienden el mismo mensaje `mover(jardinero, direccion)`:

- `enElPiso`: cualquier flecha arranca un recorrido completo.
- `enLaEscalera`: las verticales suben o bajan un escalón, las horizontales arrancan un recorrido.
- `deslizandose`: no hace nada, porque las flechas se ignoran hasta que frene.

Cambiar de estado es reapuntar esa referencia a otro objeto. Antes esto eran dos booleanos (`deslizando` y `enEscalera`) que el jardinero tenía que combinar con ifs.

El juego representa cada celda lógica con cuatro subceldas de renderizado. Cada ejecución de
`jardinero.animarPaso()` avanza una subcelda entera; al completar cuatro, procesa semillas, rampas,
cruces y victoria. El motor redondea las posiciones a celdas enteras, por eso esta subdivisión permite
que el jardinero se vea avanzar en pasos más cortos y no saltar una celda completa cada vez.

Antes de comenzar a moverse hacia una nueva celda, consulta a `partida.puedeEntrarA(...)`. Si esa celda
está bloqueada, llama a `jardinero.frenar()`. Si pisa una rampa, aplica el giro; cuando el giro apunta
contra un muro, invierte el rumbo para rebotar y seguir avanzando.

Frenar lo devuelve al estado `enElPiso` y elimina el evento periódico. Así el jardinero puede recibir una nueva dirección.

**La escalera es la excepción al deslizamiento.** Al pisarla, el jardinero se frena y queda parado en ella. Mientras siga ahí, las flechas verticales lo mueven de a una sola celda en vez de deslizarlo; si se mueve en horizontal, se baja de la escalera y vuelve a deslizarse hasta chocar, como siempre. Y cuando da un escalón de más y del otro lado ya no hay escalera, tampoco se queda frenado en el aire: se baja y sigue de largo hasta chocar. Para que la escalera no tenga que preguntar qué flecha se apretó, cada dirección sabe si es vertical: `arriba` y `abajo` contestan que sí, `izquierda` y `derecha` que no.

### 3.5 Interacción con semillas y cruces

Los elementos del tablero no necesitan que el jardinero conozca su tipo concreto. Cada uno responde al mensaje `pisadoPor(jardinero)`.

- Una semilla llama a `jardinero.recoger(self)`.
- Una cruz llama a `jardinero.plantarEn(self)`.
- Un charco de barro llama a `jardinero.recoger(sinSemilla)`, o sea le deja las manos vacías.
- Una esquina llama a `jardinero.desviarPor(diagonal)`, pasándole su diagonal.
- Una escalera llama a `jardinero.subirseAEscalera()`.
- Un agujero llama a `jardinero.caerEn(...)` con la posición de su pareja.
- Las espinas y el vidrio ya rajado llaman a `jardinero.morir(self)`.

El jardinero guarda una referencia a la semilla actual. Al plantar, delega en esa semilla el método `aplicarEn(cruz)`. La semilla le envía `recibir(self)` a la cruz. La cruz compara la semilla recibida con la semilla que necesita y solo se florece si coinciden.

Esa comparación funciona porque hay **una sola semilla de cada color en todo el juego**: no son tres clases distintas sino tres instancias de la misma clase, y la cruz compara contra el objeto exacto.

Este diseño permite que el jardinero no tenga un solo `if` sobre con qué se cruzó: le manda el mismo mensaje a todo y cada cosa sabe qué hacer.

### 3.6 Finalización y reinicio

Después de cada paso, `partida.verificarSiTermino()` comprueba si todas las cruces cumplen `florecida()`.

La partida no resuelve eso con un if: le pregunta a su **estado** (`jugando`, `ganada` o `perdida`). Solo `jugando` se fija si ya está todo plantado; los otros dos ignoran el aviso, así que un nivel terminado no puede volver a ganarse ni perderse.

Si todas están florecidas:

1. El estado pasa a ser `ganada`.
2. Se frena al jardinero y se para el cronómetro.
3. Se le pide al selector que desbloquee el nivel siguiente.
4. Se muestra el cartel de victoria, con el tiempo en cifras y la medalla de la nota.

Si en cambio el jardinero pisa las espinas o un vidrio ya rajado, ese bloque le manda `morir(self)` y la partida pasa al estado `perdida`, para el cronómetro y muestra el cartel de derrota. **Cuál cartel se muestra lo decide el bloque que lo mató**, que contesta `imagenDeDerrota()`: no es lo mismo clavarse con las espinas que caerse por el vidrio.

Una vez terminado el nivel, ganado o perdido, las flechas no hacen nada: `presionarDireccion` también se lo delega al estado, y ni `ganada` ni `perdida` mueven al jardinero.

La tecla `R` llama a `partida.presionarReiniciar()`. El nivel se oculta y se muestra de nuevo, por lo que se vacían y vuelven a construir sus elementos desde el mapa original.

La tecla `V` vuelve a la selección de niveles.

## 4. Archivo por archivo

### `main.wlk`

Contiene el objeto `main`, que es el punto de entrada del juego.

Su método `iniciar()` configura el tablero, el título, el fondo, la pantalla inicial, las entradas del teclado y el arranque de Wollok. No contiene reglas del juego: solo prepara el entorno y conecta los componentes principales.

### `juego/bloques.wlk`

Define todo lo que vive en el tablero, empezando por la superclase de la que heredan los demás.

`Bloque` trae lo que casi todos comparten: una posición, un `esTraspasable()` que devuelve `true` y un `pisadoPor(jardinero)` que no hace nada. Cada bloque redefine únicamente aquello en lo que se aparta de ese comportamiento por defecto:

- `Valla`: la cerca que rodea el jardín y arma el laberinto. Redefine `esTraspasable()` porque bloquea el paso. Es un bloque cuadrado que llena la celda, así que varias seguidas forman un muro continuo en cualquier dirección.
- `Piedra`: bloquea el paso igual que una valla, pero en el medio del jardín.
- `CharcoDeBarro`: se puede pisar, pero al hacerlo el jardinero pierde la semilla que llevaba en la mano.
- `Esquina`: se puede pisar y desvía al jardinero. Tiene dos cosas por separado: la diagonal, que resuelve hacia dónde sale según por dónde entró, y la madera que se dibuja, que es el bloque de valla cortado en una de sus cuatro mitades. Dos maderas distintas pueden compartir la misma diagonal, por eso están separadas.
- `Espinas`: al pisarlas el jardinero muere y se pierde el nivel.
- `Escalera`: frena el deslizamiento y deja al jardinero parado en ella.
- `Agujero`: el túnel del topo. Guarda a su pareja en una lista de cero o un elemento, así no hace falta preguntar si la tiene: si el nivel dejó un agujero suelto, el `forEach` no hace nada.
- `Vidrio`: compone los estados `vidrioEntero` y `vidrioRajado`. El estado actual decide la imagen y qué ocurre al pisarlo: la primera pasada lo raja y reproduce el efecto de hielo quebrándose; la segunda mata al jardinero.

`Espinas` y `Vidrio` son los dos bloques que pueden matar, y cada uno contesta `imagenDeDerrota()` con su propio cartel.

Están juntas en un mismo archivo porque cumplen el mismo papel dentro del tablero y comparten la misma superclase.

Antes de usar clases, las vallas eran sesenta objetos repetidos (`valla1` a `valla60`) y ningún mapa podía tener más de sesenta `#`.

### `juego/cruces.wlk`

Define la clase `Cruz`, que también hereda de `Bloque`. Cada instancia tiene:

- Una posición, heredada de `Bloque`.
- La semilla que le corresponde.
- Su estado: `sinFlorecer` o `florecida`.

El estado es el mismo recurso que usa el vidrio, y por el mismo motivo: lo único que cambia al florecer es cómo se dibuja y qué pasa cuando le plantan algo. En vez de un booleano con ifs, la cruz le delega las dos cosas al objeto de estado, y florecer es reapuntar esa referencia.

`partida` crea una cruz por cada `r`, `a` o `m` del mapa con `new Cruz(...)`. Antes había seis objetos repetidos (`cruz1` a `cruz6`) y un límite de seis cruces por nivel: con la clase, ese límite desapareció.

### `juego/semillas.wlk`

Define la clase `Semilla` —que hereda de `Bloque`— y sus tres instancias: `semillaRoja`, `semillaAzul` y `semillaAmarilla`. Las tres se comportan igual, así que el comportamiento está escrito una sola vez en la clase y cada instancia solo cambia sus valores.

Cada una conoce:

- La letra que la representa en el mapa.
- La letra de su cruz correspondiente.
- La imagen de la semilla, la de la cruz, la de la flor y la del ícono en la mano.

Son **instancias y no subclases** a propósito. Lo único que cambia entre los tres colores son esos datos, no el comportamiento, así que una subclase por color solo tendría métodos que devuelven constantes distintas. Además hay una sola semilla de cada color en todo el juego, y de eso depende que la cruz pueda comparar la semilla recibida con la suya.

También define `sinSemilla`, que representa la mano vacía del jardinero y no produce ninguna acción al intentar plantar. Al entender el mismo mensaje que una semilla de verdad, evita tener que preguntar si el jardinero lleva algo.

### `niveles/nivel.wlk`

Define la clase `Nivel`. Cada instancia (`mapa1` a `mapa5`) sabe su número, su dibujo y cuántos segundos se consideran una vuelta perfecta (`tiempoIdeal`).

Tiene un solo método propio, `notaPara(segundos)`, que devuelve S, A, B, C o D comparándolos con su `tiempoIdeal`: cada nivel decide su propia exigencia.

Un nivel **no sabe si está desbloqueado**, y es a propósito: eso no es una característica suya sino del avance del jugador. La lista `selectorDeNiveles.nivelesDesbloqueados` arranca con `mapa1` y le va sumando los que se completan, y es el único lugar donde vive ese dato.

### `niveles/mapa1.wlk` a `niveles/mapa5.wlk`

Cada archivo define una instancia de `Nivel` con su dibujo. El contenido textual funciona como un plano: las posiciones de las letras y de los `#` determinan dónde aparecen las entidades y las cercas.

Un mapa no tiene ninguna lógica: es solo el dibujo. Todo lo que hay que hacer con él lo resuelve `partida`. Como los cinco entienden el mismo mensaje, `partida` los usa sin saber cuál le toca.

- `mapa1`: el tutorial. Una semilla y una cruz de dos colores, rojo y azul.
- `mapa2`: tres colores, dos cruces de cada uno.
- `mapa3`: seis cruces y un recorrido circular, donde las esquinas `D` y `O` desvían al jardinero y lo hacen dar la vuelta completa.
- `mapa4`: estrena el barro, las espinas y las escaleras. La cruz azul está encerrada arriba y la única forma de llegar es frenar en la escalera y subir escalón por escalón.
- `mapa5`: están todos los bloques juntos. Las dos cruces del medio viven en una pieza cerrada a la que se entra y se sale por los agujeros de topo, y la cruz amarilla pide cruzar el piso de vidrio.

### `juego/partida.wlk`

Es el módulo central de la lógica de una partida.

Sus responsabilidades son:

- Guardar el nivel elegido.
- Interpretar el mapa y centrarlo en el tablero.
- Crear los elementos del nivel, emparejar los agujeros y ubicar las semillas.
- Determinar si una posición es transitable, preguntándole a los elementos que están ahí.
- Encontrar los elementos de una celda.
- Mostrar y ocultar los objetos visuales, y arrancar y parar el cronómetro.
- Comprobar la victoria y la derrota, y desbloquear el nivel siguiente al ganar.
- Gestionar reinicio y vuelta a la pantalla anterior.

El mismo archivo define los tres estados en los que puede estar una partida: `jugando`, `ganada`
y `perdida`. La partida les delega todo lo que depende de en cuál está: qué barra de teclas se
muestra, si las flechas mueven al jardinero, si todavía se puede ganar o perder y qué hace la tecla
`N`. Antes esto eran dos booleanos, `ganado` y `perdido`, para tres situaciones que no pueden darse
a la vez.

### `juego/jardinero.wlk`

Define el objeto `jardinero`.

Guarda:

- Su posición.
- Su dirección actual.
- La semilla que tiene en la mano.
- Su estado de movimiento: el objeto al que le delega qué hacer con cada flecha.

Sus métodos principales son:

- `empezarEn(posicionInicial)`: reinicia su estado en una posición del mapa.
- `mover(direccion)`: no resuelve nada, se lo delega a su estado de movimiento.
- `empezarADeslizar(direccion)`: arranca un recorrido completo.
- `subirUnEscalon(direccion)`: un escalón por vez mientras siga habiendo escalera; si del otro lado ya no hay, se baja y sigue deslizándose.
- `animarPaso()`: mueve al jardinero una subcelda por tick para suavizar el recorrido.
- `avanzarUnPaso()`: calcula y ejecuta un paso lógico completo.
- `frenar()`: detiene el evento de movimiento.
- `recoger(semilla)`: cambia la semilla que lleva.
- `plantarEn(cruz)`: delega en la semilla la interacción con una cruz.
- `desviarPor(diagonal)`: le pide a la diagonal de la esquina en qué se convierte su dirección.
- `subirseAEscalera()`: lo frena y lo deja parado en la escalera.
- `caerEn(posicion)`: lo manda al otro extremo del túnel sin cortar el movimiento y sin volver a pisar lo que haya en la celda de salida.
- `morir(culpable)`: le avisa a la partida que se perdió, pasándole el bloque que lo mató.

La imagen del jardinero se obtiene de la dirección actual, por lo que cambia automáticamente al moverse.

### `juego/manoDelJardinero.wlk`

Un ícono chiquito que muestra qué semilla lleva el jardinero. Su posición es la del jardinero (así lo sigue solo) y su imagen se la pide a la semilla que tiene en la mano. Si no lleva nada, `sinSemilla` devuelve una imagen transparente, así no hace falta agregar ni sacar el ícono del juego.

### `juego/movimientos.wlk`

Los tres objetos que representan cómo se está moviendo el jardinero: `enElPiso`, `enLaEscalera` y
`deslizandose`. Los tres entienden `mover(jardinero, direccion)`, `estaDeslizando()` y
`estaEnEscalera()`, así que el jardinero los trata igual y le delega a su estado qué hacer con cada
flecha.

Antes esto eran dos booleanos dentro del jardinero (`deslizando` y `enEscalera`) que había que
combinar con ifs en cada movimiento. Ahora cambiar de forma de moverse es reapuntar una referencia a
otro objeto, y cada uno resuelve lo suyo sin preguntar nada.

### `juego/direcciones.wlk`

Define las cuatro direcciones del juego: `arriba`, `abajo`, `izquierda` y `derecha`.

Cada dirección sabe:

1. Cómo calcular la celda siguiente a partir de una posición.
2. Qué imagen debe mostrar el jardinero mientras avanza en esa dirección.
3. Cómo girar a derecha e izquierda, y cuál es su opuesta.
4. Cómo avanzar una subcelda para animar el movimiento.
5. Si es vertical (`esVertical()`), que es lo que usa la escalera para saber si corresponde subir un escalón en vez de deslizarse.

Esto evita llenar `jardinero` de condiciones distintas para cada flecha.

El mismo archivo define las dos diagonales posibles de una esquina, `diagonalCreciente` ("/") y `diagonalDecreciente` ("\"). Ninguna de las dos resuelve el rebote por su cuenta: se lo pregunta a la dirección, que es la que sabe en qué se convierte. Por eso no hay un solo `if` en todo el desvío.

### `juego/escalaTablero.wlk`

Guarda el factor de subdivisión del tablero (cuatro subceldas por celda lógica) y traduce celdas a posiciones del juego. Centralizarlo acá evita repartir el número 4 por todo el código.

### `pantallas/hud.wlk`

Todo lo que el jugador lee en pantalla. Hay una limitación del motor que explica cómo está hecho: **Wollok Game dibuja todos los textos en 12 píxeles y no hay forma de cambiarlo desde el código**, porque al objeto visual solo le pregunta `text()` y `textColor()`, nunca un tamaño. En un tablero de 1680 × 960 eso es ilegible. Las imágenes, en cambio, se dibujan a su tamaño real. Por eso acá no se usan textos: se usan imágenes que ya traen las letras dibujadas adentro.

- `barraDeTeclas`: la franja de abajo con las teclas disponibles. No sabe en qué pantalla estamos: le pregunta a `navegador.actual().imagenDeTeclas()`, y cada pantalla contesta con la suya.
- `cronometro`: cuenta los segundos del nivel con un `onTick` de 1000 ms. La partida lo arranca al mostrar el nivel y lo para al terminar.
- `Digito`: una clase para las cifras del cronómetro. Cada instancia recibe su `potencia` (100, 10 o 1) y así sabe qué cifra del número le toca mostrar. Además esconde los ceros de adelante, para que 42 segundos se lea "42" y no "042".
- `relojDePantalla`: agrupa la etiqueta "TIEMPO" y sus tres cifras, para mostrarlas y ocultarlas juntas.
- `cartelDeVictoria`: el cartel grande del final. La tabla de madera ya trae el texto dibujado, y encima se colocan las cifras del tiempo y la medalla de la nota, que es lo único que cambia de una partida a otra.
- `cartelDeDerrota`: el cartel de cuando se pierde. Su imagen se la pasa el bloque que mató al jardinero.

### `pantallas/boton.wlk`

Define la clase `Boton` (posición e imagen fijas) que usan el menú y el selector. En el selector hay además una clase `BotonDeNivel`, cuya imagen no es fija: se la pide al nivel, que la cambia según esté bloqueado o no.

### `pantallas/menuPrincipal.wlk`

Define el objeto `fondoMenu`, que tapa el césped, el objeto `tituloDelJuego` y el objeto `menuPrincipal`, que es la pantalla.

Los tres botones (jugar, configuración y salir) son instancias de la clase `Boton` y viven en una lista adentro de la pantalla, acomodados en una columna centrada. `menuPrincipal.mostrar()` recorre esa lista y los agrega al juego; `ocultar()` los quita.

El botón de jugar cambia a la pantalla de niveles. Las acciones de configuración, volver, selección de nivel, dirección y reinicio están vacías en este menú porque no corresponden a esta pantalla.

### `pantallas/selectorDeNiveles.wlk`

Define la pantalla de selección de niveles.

La lista `niveles` mantiene la relación entre el número elegido y el nivel que debe cargarse: la tecla `1` elige el primero de la lista. `nivelesDesbloqueados` indica cuáles se pueden jugar. `presionarNivel(numero)` obtiene el nivel y solo se lo pasa a `partida` si está en esa lista.

`desbloquearSiguienteA(nivel)` es lo que corre al ganar: busca con `filter` el nivel cuyo número es uno más que el recién completado y lo agrega a `nivelesDesbloqueados`. Si no existe —por ejemplo al ganar el último— el filter no encuentra nada y no pasa nada.

Esa lista es el **único lugar** donde vive el avance del jugador. El cartel de cada nivel (`BotonDeNivel`) tampoco lo sabe por su cuenta: le pregunta al selector con `estaDesbloqueado(nivel)` y según eso elige entre el cartel de madera y el gris con candado.

### `pantallas/navegador.wlk`

Centraliza la navegación entre pantallas.

La variable `actual` guarda el objeto que representa la pantalla visible. Todos los objetos de pantalla tienen métodos compatibles, como `mostrar()`, `ocultar()`, `presionarJugar()` y `presionarVolver()`, aunque algunos métodos quedan vacíos según la pantalla.

`irA(pantalla)` siempre hace tres pasos:

1. Oculta la pantalla actual.
2. Actualiza la variable `actual`.
3. Muestra la nueva pantalla.

Después vuelve a agregar la barra de teclas, para que quede siempre arriba de todo lo demás.

Gracias a esto, el teclado puede enviar mensajes a `navegador.actual()` sin conocer de antemano si está hablando con el menú, el selector o la partida.

### `utils/io.wlk`

Define `entradaTeclado`, que conecta teclas con acciones del juego.

Las teclas no modifican directamente al jardinero ni a las pantallas. En cambio, envían mensajes a la pantalla actual:

| Tecla | Mensaje |
| --- | --- |
| `J` | `presionarJugar()` |
| `V` | `presionarVolver()` |
| `R` | `presionarReiniciar()` |
| `1` a `5` | `presionarNivel(numero)` |
| Flecha arriba | `presionarDireccion(arriba)` |
| Flecha abajo | `presionarDireccion(abajo)` |
| Flecha izquierda | `presionarDireccion(izquierda)` |
| Flecha derecha | `presionarDireccion(derecha)` |
| `Q` | Detener el juego |

La tecla `C` está registrada, pero todavía no tiene comportamiento.

### `utils/sonidos.wlk`

El sonido ambiente del parque y los efectos (el click de las teclas y el hielo que se parte), más el
volumen de cada cosa.

Tiene un detalle importante de rendimiento. Wollok Game **no suelta nunca un sonido reproducido**: al
mandarle `play()` queda dentro de `game.sounds`, y lo único que lo saca de ahí es `stop()`. Y el motor
serializa esa lista entera y se la manda al navegador en **cada frame**. Como cada tecla apretada
reproduce un efecto, sin soltarlos el juego se iba llenando de sonidos muertos que se mandaban por el
resto de la partida, y se ponía cada vez más lento.

Por eso los efectos tienen un cupo: `reproducirEfecto` suelta con `stop()` el más viejo cuando ya hay
cinco dando vueltas. Cinco alcanza de sobra porque los efectos duran menos de un segundo, así que para
cuando se recicla el más viejo ya terminó de sonar.

### `utils/manager.wlk`

Define `assetsManager`, un único lugar desde el que se obtienen los nombres de las imágenes.

Contiene métodos para los fondos, el título, los botones del menú, los carteles de cada nivel (normales y bloqueados), las imágenes del jardinero, las semillas y el ícono de la mano, las cruces, las flores, la valla y las rampas, los obstáculos, las cifras del cronómetro, las medallas y los carteles de victoria y derrota.

Algunos métodos reciben un parámetro y arman el nombre, como `digito(numero)`, `medalla(nota)` o `botonDeNivel(numero)`, así no hace falta un método por cada archivo.

Centralizar los nombres de los assets permite cambiar una imagen sin tener que buscar su nombre en toda la lógica del juego.

### `tests/jardinero.wtest`

Prueba el movimiento y las reglas del jardinero usando mapas chicos creados dentro del test. Está dividido en varios `describe`, uno por tema:

- **El jardinero en el jardín**: que se desliza hasta una cerca, que recoge semillas, que no planta sin semilla, que planta una cruz del mismo color y no una de otro, que una semilla nueva reemplaza a la anterior, que la semilla queda en el tablero, que la victoria ocurre solo al plantar todas las cruces, que al ganar deja de moverse y que reiniciar devuelve el nivel a su estado inicial.
- **Los obstáculos del jardín**: que la piedra lo frena igual que una cerca, que el charco le arruina la semilla y que no lo frena.
- **Las esquinas**: que las rampas cambian el rumbo sin detener el deslizamiento, incluidas las del mapa 3.
- **El cronómetro y la nota**: que arranca en cero, que la nota empeora a medida que se tarda más y que al ganar aparece el cartel con la medalla.
- **Las cifras del cronómetro**: que cada cifra muestra la parte del número que le toca y que los ceros de adelante no se dibujan.
- **Las espinas**: que pisarlas hace perder, que aparece el cartel de derrota, que después las flechas no mueven al jardinero y que reiniciar vuelve a empezar.
- **La escalera**: que frena al jardinero, que sube de a un escalón por vez y que moverse en horizontal lo baja y lo devuelve al deslizamiento.
- **Los agujeros de topo**: que sale por el otro agujero y sigue de largo, y que no lo manda de vuelta al de entrada.
- **El piso de vidrio**: que la primera pasada lo raja y reproduce su efecto de sonido, que la segunda hace perder y que su cartel de derrota no es el de las espinas.
- **Los niveles nuevos**: que los niveles 4 y 5 se pueden ganar, jugándolos enteros con la secuencia de flechas de la solución.

El método `deslizar(direccion)` simula manualmente varios pasos porque los eventos `onTick` no avanzan automáticamente durante los tests, y frena cuando el jardinero frena.

### `tests/navegacion.wtest`

Prueba la navegación entre el menú principal, el selector de niveles y la partida.

Comprueba que:

- El juego comienza en el menú.
- `J` lleva al selector.
- Las flechas no mueven al jardinero desde el menú.
- Los cinco niveles están en el selector y solo el primero arranca abierto.
- Un nivel bloqueado no se puede jugar, y una vez desbloqueado sí.
- Completar un nivel desbloquea el siguiente.
- `V` vuelve desde una partida al selector, y desde el selector al menú.
- Cada mapa crea la cantidad esperada de cruces.

En total, entre los dos archivos, hay **54 tests**.

### `README.md`

Es la guía breve del proyecto. Contiene los nombres del equipo, una descripción resumida del juego, los controles, el comando de ejecución y el formato de los mapas.

Este archivo sirve como referencia rápida. Este documento (`EXPLICACION.md`) desarrolla con más detalle la arquitectura y el funcionamiento interno.

### `package.json`

Contiene la información básica del proyecto Wollok: nombre, versión, carpeta de recursos, versión de Wollok, autor y licencia. No contiene la lógica del juego.

## 5. Carpeta `assets`

Contiene las imágenes utilizadas por los objetos del juego, agrupadas en subcarpetas: `Fondos`, `UI`, `Jardinero`, `Semillas`, `Cruces`, `Flores`, `Cercas` y `Obstaculos`.

Los archivos de código no dibujan estas imágenes directamente: piden su nombre a `assetsManager`. El nombre incluye la subcarpeta, por ejemplo `"Semillas/red_seed.png"`. Como `assetsManager` es el único que conoce esos nombres, mover una imagen de carpeta se arregla tocando un solo archivo.

En `UI` hay, además de los botones y carteles, las imágenes de texto del HUD: las diez cifras del cronómetro, las cinco medallas de la nota, las barras de teclas de cada pantalla y el título del juego.

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
├── interpreta mapa1 ... mapa5
├── configura jardinero
├── crea los bloques del tablero
├── ubica semillas y cruces
├── maneja el cronómetro y el HUD
└── controla la victoria y la derrota

jardinero
├── usa direcciones
├── consulta las reglas de partida
└── interactúa con los bloques que pisa
```

La idea más importante es que cada módulo tenga una responsabilidad concreta: los mapas describen datos, las semillas y cruces resuelven sus propias interacciones, `partida` administra el tablero, `jardinero` administra el movimiento, las pantallas administran la navegación y `entradaTeclado` conecta el teclado con esas acciones.

## 7. Dónde está la herencia, dónde la composición y dónde el polimorfismo

**Herencia.** Está en la jerarquía de `Bloque`. La superclase define el comportamiento por defecto de cualquier cosa que viva en el tablero —tiene una posición, se puede pisar, y al pisarla no pasa nada— y las diez subclases redefinen con `override` solamente aquello en lo que se apartan: `Valla` y `Piedra` el `esTraspasable()`, y el resto el `pisadoPor()`.

Se usa ahí porque ahí hay repetición de verdad. Donde lo único que cambiaba eran datos —las semillas, los niveles, las cifras del cronómetro, los botones— se usó una clase con parámetros y varias instancias, que es lo que corresponde cuando no hay comportamiento distinto que redefinir.

**Polimorfismo.** El caso principal es el jardinero: no pregunta nunca con qué se cruzó. Cuando llega a una celda le manda `pisadoPor(self)` a todo lo que haya ahí, y cada cosa sabe qué hacer con él. Lo mismo con `esTraspasable()`: el jardinero solo pregunta si puede entrar, y cada bloque contesta.

Hay otros tres lugares donde se apoya la misma idea:

- **Las pantallas.** Menú, selector y partida entienden los mismos mensajes y cada una ignora los que no le sirven, así el teclado le habla siempre a `navegador.actual()` sin saber cuál es.
- **La mano vacía.** `sinSemilla` entiende `aplicarEn(cruz)` y no hace nada, así nunca hay que preguntar si el jardinero lleva algo.
- **El cartel de derrota.** Cada bloque que puede matar contesta `imagenDeDerrota()` con el suyo. Si mañana aparece otro bloque que mate, alcanza con que conteste ese mensaje: no hay que tocar ni la partida ni el jardinero.

**Composición.** Donde una característica **cambia durante la vida del objeto**, no se usa herencia
sino una referencia a otro objeto, que se reapunta cuando el estado cambia. Un objeto no puede cambiar
de clase, pero sí puede cambiar a quién le delega. Hay seis casos:

| Qué cambia | Quién lo tiene | Objetos posibles |
|---|---|---|
| Cómo se está moviendo el jardinero | `jardinero.estado` | `enElPiso`, `enLaEscalera`, `deslizandose` |
| En qué está la partida | `partida.estado` | `jugando`, `ganada`, `perdida` |
| Si el vidrio ya se pisó | `Vidrio.estado` | `vidrioEntero`, `vidrioRajado` |
| Si la cruz ya floreció | `Cruz.estado` | `sinFlorecer`, `florecida` |
| Hacia dónde desvía una esquina | `Esquina.diagonal` | `diagonalCreciente`, `diagonalDecreciente` |
| Hasta dónde llegó el jugador | `selectorDeNiveles.nivelesDesbloqueados` | la lista de niveles abiertos |

Los cuatro primeros son estados que cambian solos mientras se juega: el jardinero se sube a una escalera,
la partida se gana, el vidrio se raja, la cruz florece. Los otros dos no cambian, pero igual son composición: la esquina **tiene** una
diagonal en vez de ser una subclase por cada tipo de giro, y el avance del jugador vive en una lista en
vez de ser un booleano repartido por cada nivel.

El caso de la esquina muestra bien por qué conviene: hay cuatro maderas distintas pero solo dos formas
de desviar, así que con herencia harían falta cuatro subclases y dos de ellas repetirían el código de
las otras dos. Con composición, la madera es un dato y la diagonal es a quién le delega.
