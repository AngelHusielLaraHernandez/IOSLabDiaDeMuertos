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

Fuente actual: `Downloads/blender final/Ofrenda_actualizada.blend`, integrada el 14 de octubre de 2026. El archivo de trabajo anterior se conserva en la misma carpeta.

El USDZ contiene 131 objetos de malla, incluida la pared `fondo__001`. Se añaden las cañas, los tejocotes con sus hojas, el tamal con un plato propio y el vaso de tequila. Las UV del plato se conservan; su textura tiene hasta 2048 px de lado largo y un reflejo moderado. El atlas completo de las veladoras se hornea a 2048 px; las demás imágenes se limitan principalmente a 1024 px.

Los tintes del papel picado se hornean a imágenes y sus materiales se muestran por ambas caras en RealityKit. Las luces y la cámara se configuran en el visor; la pared no se incluye al calcular el centro y el encuadre del altar.

La guía completa está en `output/pdf/Guia_Blender_a_Xcode.pdf` y en `Downloads/blender final`. El script reproducible está en `Downloads/blender final/Herramientas/Preparar_y_exportar_Xcode.py`.

La configuración del proyecto y la rama `angel` se conservan. No se hacen commits ni push. Los archivos reservados de las vistas siguen vacíos.
