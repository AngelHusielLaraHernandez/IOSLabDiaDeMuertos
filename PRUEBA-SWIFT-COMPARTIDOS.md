# Prueba: Swift compartidos y Xcode local

Esta prueba pertenece a `betaPruebaVersion26.2`. El proyecto `.xcodeproj` de la raíz queda como plantilla compartida. Cada persona abre una copia en `ProyectoLocal/`, ignorada por Git, que referencia el código y los Assets de `OfrendaDiaDeMuertosProyecto/` sin copiarlos.

## Preparar cada Mac una sola vez

En Terminal, dentro del repositorio y en la rama de pruebas:

```sh
python3 Scripts/crear-proyecto-local.py --ios-minimo 26.2
open ProyectoLocal/OfrendaDiaDeMuertosProyecto.xcodeproj
```

Una Mac que quiera conservar iOS 26.4 como mínimo puede usar `--ios-minimo 26.4` en la primera ejecución. Después se puede ajustar el mínimo, la firma y demás opciones directamente en el proyecto local. Volver a ejecutar el script conserva el proyecto existente sin sobrescribir sus ajustes.

Cierra la ventana del proyecto de la raíz para evitar editar accidentalmente la plantilla. El formato local inicial es compatible con Xcode 16.0 y posteriores. El código sigue necesitando APIs y sintaxis compatibles con el Xcode más antiguo del equipo.

## Compartir código

Edita los Swift que muestra el proyecto local: son los mismos archivos del repositorio. Los archivos nuevos se guardan dentro de `OfrendaDiaDeMuertosProyecto/` y su carpeta sincronizada los incorpora al proyecto. Si agregas archivos arrastrándolos, elige **Reference files in place** y verifica que permanezcan en esa carpeta; copiar archivos a `ProyectoLocal/` dejaría esas copias fuera de Git.

```sh
python3 Scripts/commit-swift.py "Cambio en la pantalla de inicio"
```

Este comando prepara altas, modificaciones y eliminaciones de `.swift` de la carpeta compartida. Rechaza un commit si ya hay otros tipos de archivos preparados. No hace push, no instala hooks y no cambia ajustes globales de Git. En esta prueba tampoco permite hacer commits desde `main`.

Después de revisar el commit puedes subirlo explícitamente a tu rama con `git push`. Para recibir cambios en una rama sin trabajo pendiente, usa `git pull --ff-only`. El pull actualiza los Swift compartidos, pero no toca `ProyectoLocal/`; cualquier Swift nuevo aparece en la carpeta sincronizada de Xcode.

## Alcance y cuidado al cambiar de rama

- `Assets`, modelos 3D y otros recursos necesarios siguen compartidos. Cuando haya que modificarlos, se revisan y publican por separado; no se ignoran todos los archivos que no sean Swift.
- `.gitignore` protege la copia local. No ignora los cambios de la plantilla de la raíz porque esa plantilla ya está registrada en Git.
- Git no puede garantizar que cualquier commit manual contenga únicamente Swift. Esa selección la asegura el comando de esta prueba. Un commit manual o un `git add .` puede incluir otros archivos compartidos.
- El proyecto local conserva sus ajustes incluso al cambiar de rama. Al volver a `main`, puedes abrir el proyecto compartido de la raíz, que conserva la configuración 26.4. Los scripts de esta prueba estarán disponibles en la rama beta cuando se publiquen.
- No ejecutar `git clean -x`: esa opción también elimina archivos ignorados, incluida la configuración local.

## Validación

Comprobado con dos clones aislados, sin publicar nada en GitHub:

- Un cambio Swift se compartió mediante commit, push y pull a un remoto local de prueba.
- Las configuraciones locales con mínimos iOS 26.2 y 26.4 conservaron exactamente su contenido.
- Se comprobaron altas en subcarpetas, modificaciones y eliminaciones de Swift.
- El generador conservó los ajustes de un proyecto local existente.
- El comando rechazó un commit que tenía configuración de Xcode preparada.
- La copia local real compiló con Xcode 27 y su SDK de simulador iOS 27. La prueba en la Mac con Xcode 26.2 sigue pendiente.

Referencia: [Git no ignora cambios de archivos ya registrados](https://git-scm.com/docs/gitignore) y [Apple permite referenciar archivos en su ubicación original](https://developer.apple.com/documentation/xcode/managing-files-and-folders-in-your-xcode-project).
