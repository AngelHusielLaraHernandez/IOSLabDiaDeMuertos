# Estructura y visor de Blender

Por ahora la aplicación muestra únicamente la ofrenda 3D. Los archivos de funciones futuras están vacíos.

- `ContentView.swift`: pantalla provisional del visor.
- `Features/Ofrenda/OfrendaModelView.swift`: carga con RealityKit, cámara, iluminación y gestos.
- `Resources/Models/Ofrenda.usdz`: ofrenda corregida, con texturas incluidas.
- `Core/`, `Models/`, `Services/`: archivos Swift reservados, sin implementación.
- `Features/Inicio/`, `Features/Indagar/`, `Features/MiOfrenda/`: archivos Swift vacíos para las futuras vistas.
- `Features/Ofrenda/OfrendaView.swift` y `ElementDetailView.swift`: también reservados, sin código.

## Controles del visor

Un dedo gira; pellizcar acerca o aleja; dos dedos desplazan. Doble toque o el botón superior restablecen la cámara. El encuadre se adapta al tamaño y orientación de la pantalla.

## Modelo

Fuente: `Downloads/blender final/Ofrenda_morado_y_flores.blend`, guardada el 13 de octubre de 2026. Se conservan las posiciones y orientaciones de la escena final; no se guarda ningún cambio en el Blender original.

Se exportan 119 objetos de malla sin el fondo de estudio, las cámaras ni las luces de Blender. El USDZ incluye sus texturas con un máximo de 1024 px; el papel picado usa recorte alfa y material visible por ambas caras en RealityKit. La luz principal, el relleno y las luces cálidas de velas se configuran en el visor.

La configuración del proyecto y la rama actual `angel` se conservan. No se hacen commits ni push. Los archivos `Item.swift` y `Prueba.swift`, existentes antes de esta integración, permanecen sin cambios.
