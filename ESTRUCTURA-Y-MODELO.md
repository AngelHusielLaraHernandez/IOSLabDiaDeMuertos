# Estructura del proyecto de ofrenda

Actualización: 16 de octubre de 2026. Organización y ajustes de interfaz sobre el trabajo existente del equipo, sin añadir funciones ni modificar el proyecto de Xcode.

## Carpetas

```text
OfrendaDiaDeMuertosProyecto/
├── App/
│   ├── OfrendaApp.swift         # Punto de entrada único
│   ├── ContentView.swift        # Una sola presentación de la entrada
│   └── AppTabsView.swift        # Ofrenda, Historias y Mi ofrenda
├── Core/
│   ├── DesignSystem/            # Paleta, botones y controles de las hojas
│   ├── Images/                  # Decodificación de fotos con tamaño limitado
│   └── Models/Item.swift        # Modelo original de la plantilla, conservado
├── Features/
│   ├── Inicio/                 # Vistas y puente WKWebView de la entrada al Mictlán
│   ├── Ofrenda/
│   │   ├── Models/             # Elemento, hitos, fuentes y estado del visor
│   │   ├── Data/               # Catálogo de elementos y datos de calaveritas
│   │   ├── ThreeD/             # Visores, caché compartida y configuración de render
│   │   └── Views/
│   │       ├── OfrendaView.swift
│   │       ├── Detalle/        # Hoja común, plantilla, cronología y fuentes
│   │       └── Elementos/      # Contenido existente de los ocho elementos
│   ├── Historias/Views/        # Catálogo de historias existente
│   └── MiOfrenda/
│       ├── Models/             # Perfil y pasos de personalización
│       ├── Services/           # Plantilla local de versos existente
│       └── Views/              # Flujo de retrato, encuadre, gustos y resultado
├── Resources/
│   ├── Models/                 # Ofrenda.usdz y foto.usdz, sin cambios
│   └── Web/mictlan-entrada.html # Animación local existente, sin dependencias remotas
└── Assets.xcassets/
```

Los archivos vacíos reservados se retiraron; no contenían implementación. La vista provisional `OfrendaScreen`, que ya no era accesible desde la aplicación, dejó de duplicar el visor. Los dos visores activos se conservan: el de exploración proyecta las etiquetas del altar y el personalizado aplica la fotografía.

Xcode usa una carpeta sincronizada con el sistema de archivos. Las rutas nuevas se detectan automáticamente, sin editar `project.pbxproj`. Las copias creadas por `Scripts/crear-proyecto-local.py` apuntan a esta misma carpeta; también reciben la reorganización. Se mantiene el destino mínimo iOS 26.2 y no se cambia la configuración global del equipo.

## Interfaz

Se conservan la paleta morada, los acentos de cempasúchil y los tres apartados de Figma. La navegación inferior usa `TabView` nativo. Los controles usan `.glass`, `.glassProminent` o `.glassEffect` según su función. Las superficies de lectura conservan el morado para mantener legibles los textos y evitar superponer capas de cristal.

Los detalles de los ocho objetos se presentan con `.sheet(item:)`, indicador de arrastre y cierre. Desde el altar se abren a media pantalla y admiten expansión completa, dejando visible arriba el elemento enfocado. Desde Historias conservan las alturas de 68 % y completa. Se retiró el fondo opaco que cubría el material nativo de iOS. Las fuentes se abren en una segunda hoja y vuelven al elemento. Historia, significado, cronología y las dos formas de calaveritas mantienen su contenido.

La entrada sigue siendo la animación HTML del Mictlán que añadió el equipo. Se eliminó la presentación duplicada en `App` y `ContentView`, el modelo 3D se carga solo después de entrar, se limpia el puente WebKit al cerrar y se respetan los ajustes de reducir movimiento. No se implementó otra animación ni se recuperó la vela inicial.

## Correcciones en los flujos existentes

- Las etiquetas del altar distribuyen sus áreas de toque de 44 puntos para evitar superposiciones, y el contenido admite desplazamiento en horizontal o con texto de accesibilidad.
- Los elementos usan un identificador estable y el progreso comienza sin marcar una visita ficticia a Flores.
- El selector de fotos usa una sola presentación nativa. Cambiar la foto desde el resultado regresa al resultado al confirmar el encuadre.
- Los botones «Volver» y «Volver a la ofrenda» respetan su destino correspondiente.
- El retrato y el encuadre admiten desplazamiento vertical; el recorte usa el tamaño real de la vista previa.
- La afición del resumen y los versos se elige de forma estable, ordenando el conjunto existente.
- Se conserva la generación local de versos; no se integra un servicio de IA, guardado ni una función adicional.

## Modelo y controles

Un dedo gira entre −65° y +65°; la inclinación se limita entre −8° y +22° para mantener visible el frente. Estos límites se comparten con el visor personalizado. Pellizcar acerca o aleja dentro de un rango acotado; dos dedos desplazan. Doble toque o el botón superior restablecen la cámara, el enfoque y el encuadre.

Al tocar una etiqueta, la cámara se acerca un 15 % dentro del límite de zoom y sitúa su anclaje en la parte superior del visor antes de abrir la hoja del elemento. La transición dura 0.36 segundos y se omite si está activo Reducir movimiento. Al cerrar la hoja se recupera en 0.28 segundos el encuadre previo, incluido el zoom que el usuario tenía antes de seleccionar. Las tareas se cancelan al restablecer o desmontar el visor; no se añade una suscripción permanente por fotograma.

Las etiquetas quedan separadas por al menos 16 puntos, reservan el control de restablecer y se ocultan si su anclaje sale del área visible o queda detrás de la cámara. La vista general admite ocho; al acercar, el máximo se reduce a cinco, tres y dos. Se da prioridad al elemento seleccionado y a los anclajes próximos al centro. El tamaño del visor y los cambios de cámara actualizan esta distribución.

Fuente del modelo: `Downloads/blender final/Ofrenda_actualizada.blend`, integrada el 14 de octubre. El USDZ y sus texturas no se modificaron en esta reorganización. El visor de exploración conserva la decisión del equipo de ocultar la pared (`ocultarParedDeFondo`); el recurso exportado sí la contiene. El visor personalizado conserva su carga y sus materiales.

La guía de exportación sigue en `output/pdf/Guia_Blender_a_Xcode.pdf` y en `Downloads/blender final`. El script de exportación está en `Downloads/blender final/Herramientas/Preparar_y_exportar_Xcode.py`.

## Referencias de diseño

- [Prototipo de Figma](https://www.figma.com/proto/NsbYsZVwlG0VF8bH8l8ThD/Ofrenda-viva-%C2%B7-Historias-del-D%C3%ADa-de-Muertos?page-id=20%3A2&node-id=20-4058)
- [Apple: Liquid Glass en vistas personalizadas](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Apple: materiales y jerarquía entre controles y contenido](https://developer.apple.com/design/human-interface-guidelines/materials)

## Optimización y estabilidad

La revisión detectó trabajo innecesario, pero no encontró un informe de crash de la app que permita atribuir con certeza todos los reinicios a una única causa.

- Se elimina `SceneEvents.Update`: la proyección de las etiquetas solo se calcula al cargar, al cambiar el tamaño o al mover la cámara. Se redondea a medio punto y se publica fuera de `layoutSubviews` para evitar invalidaciones repetidas de SwiftUI durante su propio layout.
- Solo se monta el visor de la pestaña visible y con la escena activa. El estado del perfil y de la navegación se mantiene. Al desmontar, se cancelan tareas y publicaciones, se eliminan gestos y anclajes y se liberan los callbacks.
- `OfrendaAssets` coordina las cargas y crea copias que comparten mallas y texturas. La caché admite dos recursos y se vacía ante avisos de memoria o al pasar a segundo plano.
- Las fotos se decodifican mediante ImageIO con un lado máximo de 2048 píxeles antes del encuadre. El recorte usa escala 1 y produce 1024 × 1280 píxeles; la textura aplicada al modelo se limita a 1024 píxeles de lado largo. Se sustituye la API síncrona de texturas obsoleta por su inicializador asíncrono.
- Se corrige una rotación con eje nulo en el recurso de foto, usando una orientación identidad válida.
- El visor configura su escala de contenido como máximo a 2 al montarse en una ventana, sin renegociarla dentro de cada `layoutSubviews`. Los textos y botones nativos conservan su escala normal. En el simulador se desactivan HDR y las sombras direccionales, y se usan una luz principal y una de relleno, conservando las llamas emisivas. En el iPhone se mantienen las seis luces y la sombra direccional; los radios de las luces globales se acotan al volumen del altar.
- La entrada HTML y el visor no se cargan a la vez. Se pausan animaciones HTML ocultas y se limpian temporizadores al salir. SwiftUI expande el contenedor WebKit a todo el espacio; HTML y body tienen ancho y alto explícitos, la escena ocupa el contenedor y los controles respetan las áreas seguras. Se incluye un ajuste CSS para pantallas horizontales.
- `#Preview("Ofrenda · Modelo 3D")` abre las pestañas directamente y utiliza el mismo visor RealityKit y el mismo USDZ que la aplicación. Se retiraron la sustitución por imagen, su entorno especial y el recurso estático. La entrada HTML continúa en el arranque normal de la app.

El USDZ contiene 41 imágenes: su tamaño RGBA teórico al decodificarse es de 151.8 MiB (202.5 MiB si se incluye una cadena completa de mipmaps). Esto es un presupuesto de imágenes, no una medición de memoria GPU real. El recurso tiene 131 mallas, 516 576 triángulos y 32 materiales principales. Los panes y los ramos son las piezas con más geometría. Los archivos USDZ originales se conservan sin reducción adicional.

Se comprobaron 832 escenarios de distribución con distintos tamaños, cuatro niveles de zoom, anclajes coincidentes, aleatorios y fuera de pantalla. Las comprobaciones incluyen separación, contención, límites de cantidad, exclusión del control de restablecer, prioridad del elemento seleccionado y límites matemáticos de giro/zoom. Las compilaciones locales para simulador ARM64 y para iPhone genérico (sin firma) finalizan correctamente con destino mínimo iOS 26.2. El Xcode instalado es 27.0; la ejecución de prueba usa iOS 26.5.

La reorganización también mueve el HTML: ese recurso debe viajar junto con los Swift si se comparte este cambio completo. El script para commits de solo Swift no incluye recursos por sí solo.

No se realizan commits ni push como parte de esta tarea. La validación local usa el Xcode instalado; no equivale a una compilación ejecutada en la Mac de un compañero con Xcode 26.2.

La prueba final en el simulador comprobó visualmente la entrada a pantalla completa en vertical y horizontal, la transición al altar, sus ocho etiquetas y la hoja nativa de calaveritas. El usuario también confirmó que el altar abre. La compilación desde la ventana de Xcode finalizó con `Build Succeeded`. La vista previa estática usada durante esa prueba se retiró después a petición del usuario: el Canvas vuelve a cargar el modelo 3D real. Se comprobó visualmente esa carga en Xcode y la compilación para simulador finalizó correctamente tras retirar la imagen.

Dos registros de Time Profiler de unos diez segundos, con el altar en reposo en el mismo simulador, dieron aproximadamente 27.1 % y 24.1 % de un núcleo de CPU antes y después del ajuste de luces y escala. Es una comparación corta y orientativa, no una medición de FPS ni un resultado de iPhone físico. Las muestras sitúan el trabajo restante en el renderizado de RealityKit; no mostraron un bucle continuo de layout de la app. La siguiente reducción importante de geometría debería centrarse en pan y ramos, con revisión visual del modelo.

La automatización de Device Hub permitió tocar botones y abrir hojas, pero sus arrastres no produjeron un gesto visible ni en el modelo ni en el indicador de la hoja. Por ello no se declara una prueba completa de giro/pellizco o fluidez física. Se comprobó el HTML tras girar el simulador a horizontal y volver a vertical; no se modificó la configuración de orientaciones del proyecto.

Se añadieron los encabezados solicitados a 30 archivos Swift sin encabezado (incluidos los dos archivos nuevos de esta interacción), con Angel Lara y fecha 16/10/26. Los encabezados y autores preexistentes se conservaron.

La prueba final de esta interacción se realizó en el simulador iPhone 17 Pro Max con iOS 26.5: los ocho botones abrieron la hoja correspondiente y, después de cada cierre, se recuperaron las ocho etiquetas y el encuadre previo. Se comprobó visualmente el enfoque del pan por encima de la hoja y la reducción a cinco etiquetas durante ese acercamiento. Las compilaciones finales para simulador e iPhone genérico terminaron correctamente. La prueba matemática valida el límite frontal de rotación; el gesto multitáctil físico sigue pendiente de validación en un dispositivo.
