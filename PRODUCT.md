# Ofrenda Día de Muertos

Aplicación didáctica nativa para conocer los elementos de una ofrenda del Día de Muertos mediante un altar 3D interactivo, fichas de historia y significado, referencias culturales y lectura en voz alta. La personalización permite conservar fotografías, gustos y la selección de elementos del altar. Las calaveritas literarias se generan en una pestaña propia usando los datos guardados.

## Integración confirmada: guía y créditos

La primera vez que se abre el recorrido de la ofrenda, la guía debe esperar a que el altar termine de cargar. Atenúa la pantalla, destaca controles reales y explica gestos, historias, progreso, fotografías, ocultar referencias, captura para compartir y personalización. Permite avanzar, retroceder y omitir. Completar u omitir se recuerda en el dispositivo. La guía debe poder repetirse desde Créditos y no altera los datos guardados de las personas.

Créditos es la quinta sección del TabView. Contiene Angel Husiel Lara Hernandez, Adolfo de Jesus Garcia Cortes, Victor Jaziel Flores Colin y Rodrigo Lugo Manzano. Debajo aparece «Hecho en el iOS Development Lab.».

## Límites de esta integración

Se conserva el sistema visual y la sesión 3D actuales. Las explicaciones se adaptan al tamaño de texto y conservan las acciones de navegación visibles. No se añaden cuentas, red ni un segundo modelo para la guía. La validación de esta etapa se realiza en iPhone; el usuario ha indicado que todavía no se pruebe en iPad. Este documento registra el propósito y el alcance existentes; no define una identidad visual nueva.

## Ampliación confirmada: ayuda dentro de las hojas

La guía también se presenta dentro de las hojas propias de la aplicación, con una preferencia independiente por tipo de interfaz y una opción de repetirla. Las fichas enseñan secciones, lectura, objeto 3D y cierre; las demás ayudas acompañan fotografías, recorrido, fuentes, fechas, personalización y calaveritas. Los controles del sistema de Apple se explican antes de abrirlos. La acción de captura de la ofrenda usa el símbolo de compartir. En Mis ofrendas, las acciones Eliminar y Crear tienen texto explícito debajo del título y conservan su comportamiento actual.

En las fichas, cada sección recibe su propia explicación y se selecciona durante ese paso; al finalizar se recupera la selección anterior. La hoja de calendario no muestra un botón de interrogación.

## Ajuste confirmado: identidad por retrato

En Mis ofrendas, Eliminar queda arriba a la izquierda y Crear arriba a la derecha, en tamaño compacto; la ayuda queda abajo a la derecha. Con texto de accesibilidad se usan símbolos con nombres accesibles completos.

En las ofrendas personalizadas, dos marcos requieren dos nombres y dos músicas distintos. Los gustos y recuerdos son compartidos. El altar y las calaveritas muestran el primer nombre en negritas, con énfasis naranja; el generador permite elegir a la persona. Para reemplazar una foto personal es obligatorio cambiar también el nombre, ignorando diferencias cosméticas de mayúsculas, acentos o espacios. La edición de fotos se confirma mediante Guardar.

La tarjeta de personalización aparece solo en el altar general. Las fichas conservan su ayuda y su botón inferior de regreso, sin X duplicada. Sus secciones usan el control segmentado nativo cuando caben y una fila de botones Liquid Glass desplazable cuando el ancho necesario desborda, incluido Dynamic Type. Calaveritas también tiene ayuda contextual.


## Ajuste confirmado: general, selectores y calaveritas de azúcar

La ofrenda general permite elegir uno o dos marcos, seleccionar la fotografía del marco único y guardar tanto la cantidad como el marco principal. No solicita nombres ni músicas; los datos de identidad son exclusivos de las ofrendas personalizadas. Permite cambiar las fotografías sin renombrar a una persona. Cambiar la cantidad conserva las fotografías guardadas, incluida la del marco oculto. Las personalizadas mantienen la validación de dos identidades y dos músicas distintas, así como el cambio de nombre obligatorio al reemplazar una foto personal guardada.

Historias usa dos opciones simétricas de igual ancho: Elementos y Celebraciones. Los selectores de secciones usan `UISegmentedControl` cuando caben, conservando su arrastre y material nativos. Cuando el ancho requerido desborda, muestran botones Liquid Glass `.glass` y `.glassProminent` dentro de un `ScrollView` horizontal, con selección accesible, textos completos y zonas táctiles de al menos 44 puntos. Eliminar permanece a la izquierda y el botón de creación a la derecha dice solamente Crear.

En la ficha de las calaveritas de azúcar, Significado reúne también Elaboración: se preservan ambos textos y la lectura en voz alta de ambos. Las cuatro secciones son Significado, Historia, Mapa y Conocer más. La guía `.azucar` describe esta distribución y usa versión 3. La ayuda `.marcosGeneral` explica la edición de fotografías sin identidad de forma independiente de la ayuda personalizada.


Este ajuste conserva el morado, el naranja, la tipografía SF y los materiales nativos existentes. No sustituye la identidad ni la composición global; se mantiene la ausencia de `DESIGN.md` y de su sidecar. La validación registrada reúne 61 comprobaciones de retratos y 177 de guía (238), además de una compilación exitosa para el simulador de iPhone. La revisión final confirmó resuelta la accesibilidad del selector desbordado y emitió `ship`, sin pendientes en ese alcance. Se verificaron toque y arrastre en iPhone 17 Pro Max con iOS 26.5, texto habitual y AX3, ambas opciones de Historias y las cuatro secciones de azúcar. Las capturas finales están en `.impeccable/review/selectores`. El veredicto se limita al ajuste de selectores revisado y no implica una revisión de toda la aplicación.


## Ajuste de creación por retrato

Crear abre un destino mediante `navigationDestination`, con un único regreso nativo de iOS en el primer paso. `PersonalizarRetratoView` no repite Volver dentro del contenido y presenta la ayuda en la barra superior. Los pasos siguientes conservan su regreso propio; el flujo oculta allí el regreso nativo del destino para evitar duplicarlo.

Con dos marcos, el formulario y la opción de fotografía pertenecen únicamente al retrato seleccionado. `DatosRetratosView` recibe esa selección tanto en la creación como en el editor de fotografías personalizadas. Siguiente valida los datos del marco 1 sin exigir todavía los del segundo y selecciona automáticamente el marco 2. Desde este, Añadir gustos y recuerdos continúa cuando ambas identidades son válidas. `ConfiguracionMarcos.errorIdentidad(en:)` comprueba el marco indicado; `errorIdentidad` comprueba el conjunto de marcos visibles. Se mantienen dos nombres y dos músicas diferentes y los gustos y recuerdos compartidos. Elegir fotos personales es opcional: se pueden conservar las fotografías de ejemplo.

La guía `.crearOfrenda` usa versión 2 y explica el orden: datos y fotografía del retrato seleccionado, Siguiente al segundo marco y después gustos compartidos. Los selectores nativos de Historias y las fichas reducen su altura habitual de 52 a 44 puntos, conservando las mitades simétricas y el arrastre nativo. Su altura se adapta al texto. Al desbordar se mantienen los botones Liquid Glass desplazables, con zonas táctiles de al menos 44 puntos.

La validación de este ajuste pasó 65 comprobaciones de retratos y 177 de guía (242), además de la compilación para el simulador de iPhone. Una prueba de interfaz en una copia aislada confirmó datos y fotografías separados y el avance después de elegir Foto A y Foto B. Las capturas están en `.impeccable/review/flujo`. Una revisión final independiente emitió `ship`, sin correcciones materiales pendientes, para este refinamiento local en iPhone 17 Pro Max con iOS 26.5: seis capturas, datos y fotos por marco, avance al marco 2 y a gustos, y selectores con texto habitual y AX3. El veredicto se limita a ese alcance. No se prueba iPad ni se realizan operaciones de Git en esta etapa.

Se conserva el sistema SF, morado, naranja y materiales nativos; este refinamiento local no añade `DESIGN.md` ni `.impeccable/design.json`.


## Ajuste de ayuda en Calaveritas

El botón **?** de `CalaveritasLiterariasView` y `GuardarCalaveritaView` pasa de la barra superior izquierda a la esquina inferior derecha, en un `safeAreaInset` inferior alineado a la derecha, con 24 puntos de margen derecho y 8 de margen vertical. Se mantienen las guías `.generador` y `.guardarCalaverita` y la biblioteca de calaveritas guardadas.

La compilación pasó y se confirmó que ambos botones abren su guía en iPhone 17 Pro Max con iOS 26.5; las capturas están en `.impeccable/review/ayuda-calaveritas/phone-calaveritas.png` y `phone-guardar.png`. No se verificó visualmente el teclado de software ni se probó iPad. Las 242 comprobaciones de la etapa anterior no se atribuyen a este ajuste. La revisión final independiente emitió `ship`, sin correcciones pendientes, para esta reubicación de ayuda en el iPhone indicado; el veredicto se limita a ese alcance.
