//
//  CalaveritasRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

/// Pruebas sobre los mismos modelos y servicios compilados por la app, sin tocar sus documentos.
@main
struct CalaveritasRegression {
    @MainActor
    static func main() throws {
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent("calaveritas-regression-\(UUID())")
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: carpeta) }
        var comprobaciones = 0
        func verificar(_ valor: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(valor(), mensaje)
            comprobaciones += 1
        }

        var perfil = PersonalizacionOfrenda()
        verificar(!perfil.estaCompleta, "Un perfil vacío debe estar bloqueado")
        perfil.nombre = " \n "
        perfil.comidaFavorita = "\t "
        verificar(!perfil.estaCompleta, "Los espacios no son parámetros válidos")
        perfil.nombre = "Elena"
        perfil.comidaFavorita = "Tamales"
        verificar(perfil.estaCompleta, "Los gustos opcionales no deben bloquear un perfil válido")

        let urlPerfiles = carpeta.appendingPathComponent("ofrendas.json")
        let ofrendas = OfrendasManager(urlGuardado: urlPerfiles)
        verificar(ofrendas.ofrendasParaCalaveritas.isEmpty, "Sin guardado no debe habilitarse el generador")
        ofrendas.ofrendas = [perfil]
        verificar(ofrendas.ofrendasParaCalaveritas.isEmpty, "Editar en memoria no equivale a guardar")
        verificar(ofrendas.agregarOfrenda(perfil), "El perfil debe guardarse")
        verificar(ofrendas.ofrendasParaCalaveritas == [perfil], "Solo el guardado exitoso desbloquea el perfil")
        ofrendas.ofrendas[0].comidaFavorita = "Mole sin guardar"
        verificar(ofrendas.ofrendasParaCalaveritas[0].comidaFavorita == "Tamales", "El generador debe usar la última versión guardada")
        verificar(OfrendasManager(urlGuardado: urlPerfiles).ofrendasGuardadas == [perfil], "Los perfiles deben recuperarse al abrir la app")
        var otroPerfil = PersonalizacionOfrenda()
        otroPerfil.nombre = "Luis"
        otroPerfil.comidaFavorita = "Mole"
        verificar(ofrendas.agregarOfrenda(otroPerfil), "Debe poder guardarse una segunda ofrenda")
        verificar(ofrendas.ofrendasGuardadas.first?.comidaFavorita == "Tamales", "Guardar otra ofrenda no confirma ediciones ajenas sin guardar")
        let noGuardable = OfrendasManager(urlGuardado: carpeta.appendingPathComponent("ausente/ofrendas.json"))
        verificar(!noGuardable.agregarOfrenda(perfil), "Un fallo de disco no puede confirmarse como guardado")
        verificar(noGuardable.ofrendasParaCalaveritas.isEmpty, "El fallo de disco no puede desbloquear la generación")

        verificar(ofrendas.idOfrendaPrincipal == nil && ofrendas.idModeloPrincipal == OfrendasManager.ofrendaGeneralID, "Sin elección se conserva la ofrenda general")
        let versionGeneral = ofrendas.versionPrincipal
        verificar(ofrendas.seleccionarOfrendaPrincipal(perfil.id), "Debe poder elegirse una ofrenda guardada")
        verificar(ofrendas.ofrendaPrincipal == perfil && ofrendas.versionPrincipal != versionGeneral, "La principal usa la versión guardada, no el borrador")
        verificar(OfrendasManager(urlGuardado: urlPerfiles).idOfrendaPrincipal == perfil.id, "La elección debe sobrevivir al reinicio")
        verificar(ofrendas.seleccionarOfrendaPrincipal(otroPerfil.id) && ofrendas.idModeloPrincipal == otroPerfil.id, "Solo una ofrenda puede ser principal")
        let versionLuis = ofrendas.versionPrincipal
        verificar(ofrendas.seleccionarOfrendaPrincipal(otroPerfil.id) && ofrendas.versionPrincipal == versionLuis, "Volver a marcar la misma no reconstruye el visor")
        verificar(!ofrendas.seleccionarOfrendaPrincipal(UUID()) && ofrendas.idOfrendaPrincipal == otroPerfil.id, "Un ID inexistente no cambia la selección")
        verificar(!noGuardable.seleccionarOfrendaPrincipal(nil) && noGuardable.mensajeErrorSeleccion != nil, "Un fallo de escritura debe explicarse")

        let carpetaSeleccion = carpeta.appendingPathComponent("seleccion-fallida")
        try FileManager.default.createDirectory(at: carpetaSeleccion, withIntermediateDirectories: true)
        let seleccionFallida = OfrendasManager(urlGuardado: urlPerfiles, urlSeleccion: carpetaSeleccion.appendingPathComponent("seleccion.json"))
        verificar(seleccionFallida.seleccionarOfrendaPrincipal(perfil.id), "Preparar una selección válida para comprobar errores de disco")
        try FileManager.default.removeItem(at: carpetaSeleccion)
        verificar(!seleccionFallida.seleccionarOfrendaPrincipal(otroPerfil.id) && seleccionFallida.idOfrendaPrincipal == perfil.id, "El check anterior se conserva si no se puede guardar el cambio")

        verificar(ofrendas.seleccionarOfrendaPrincipal(perfil.id), "Debe poder volver a la primera ofrenda")
        var perfilActualizado = perfil
        perfilActualizado.musicaFavorita = "Boleros"
        let versionAnterior = ofrendas.versionPrincipal
        verificar(ofrendas.actualizarOfrenda(perfilActualizado), "Debe guardarse la edición de la ofrenda activa")
        verificar(ofrendas.ofrendaPrincipal == perfilActualizado && ofrendas.versionPrincipal != versionAnterior, "Guardar la activa debe refrescar sus fotos y objetos")
        verificar(ofrendas.seleccionarOfrendaPrincipal(nil) && ofrendas.ofrendaPrincipal == nil, "La general debe poder elegirse desde la misma lista")
        verificar(OfrendasManager(urlGuardado: urlPerfiles).idModeloPrincipal == OfrendasManager.ofrendaGeneralID, "La elección general también debe persistir")
        verificar(ofrendas.seleccionarOfrendaPrincipal(perfil.id), "Seleccionar la primera antes de eliminarla")

        let urlEleccionDanada = carpeta.appendingPathComponent("eleccion-danada.json")
        try Data("{eleccion dañada".utf8).write(to: urlEleccionDanada)
        let eleccionDanada = OfrendasManager(urlGuardado: urlPerfiles, urlSeleccion: urlEleccionDanada)
        verificar(eleccionDanada.idOfrendaPrincipal == nil && eleccionDanada.mensajeErrorSeleccion != nil, "Una elección dañada debe recuperar la general y explicar el problema")
        verificar(eleccionDanada.seleccionarOfrendaPrincipal(nil), "Marcar la general debe reparar la elección dañada")
        verificar(OfrendasManager(urlGuardado: urlPerfiles, urlSeleccion: urlEleccionDanada).mensajeErrorSeleccion == nil, "La elección reparada debe poder recuperarse")

        let urlPoemas = carpeta.appendingPathComponent("calaveritas.json")
        let store = CalaveritasStore(urlGuardado: urlPoemas)
        let primero = CalaveritaGuardada(para: perfil, texto: CalaveritaGenerator.generar(para: perfil))
        verificar(store.guardar(primero, conNombre: "Un recuerdo con tamales"), "Debe guardarse el poema generado")
        verificar(store.contiene(primero), "La interfaz debe detectar el poema guardado")
        let duplicado = CalaveritaGuardada(para: perfil, texto: primero.texto)
        verificar(store.guardar(duplicado, conNombre: "Un recuerdo con tamales") && store.calaveritas.count == 1, "Guardar dos veces no duplica un poema")
        let segundo = CalaveritaGuardada(para: perfil, texto: CalaveritaGenerator.generar(para: perfil, evitando: primero.texto))
        verificar(store.guardar(segundo, conNombre: "Otra visita de la Flaca"), "Debe poder conservarse otra versión")
        verificar(store.calaveritas.first?.id == segundo.id, "Los poemas recientes aparecen primero")
        verificar(CalaveritasStore(urlGuardado: urlPoemas).calaveritas == store.calaveritas, "La colección debe sobrevivir al reinicio")
        verificar(store.versionGuardada(de: primero)?.titulo == "Un recuerdo con tamales", "El generador recupera el título guardado también para compartir")
        verificar(store.calaveritas.last?.titulo == "Un recuerdo con tamales", "Se conserva el nombre elegido")
        let tercero = CalaveritaGuardada(para: perfil, texto: "Versión independiente **con cariño**.\nOtro verso.")
        let antesDelFallo = try Data(contentsOf: urlPoemas)
        verificar(!store.guardar(tercero, conNombre: " \n "), "El nombre es obligatorio")
        verificar(!store.guardar(tercero, conNombre: "UN RECUÉRDO CON TAMALES"), "Se evitan títulos repetidos incluso con mayúsculas y acentos")
        verificar(!store.guardar(tercero, conNombre: String(repeating: "x", count: 81)), "Los nombres tienen un límite legible")
        let despuesDelFallo = try Data(contentsOf: urlPoemas)
        verificar(despuesDelFallo == antesDelFallo, "La validación no debe modificar la colección")
        verificar(store.guardar(tercero, conNombre: "  Cariño\n entre   versos  "), "Se normalizan los espacios del nombre")
        verificar(store.calaveritas.first?.titulo == "Cariño entre versos", "El título no contiene saltos ni espacios duplicados")
        verificar(store.calaveritas.first?.textoPlano == "Versión independiente con cariño.\nOtro verso.", "Compartir conserva versos sin los marcadores Markdown")
        verificar(store.calaveritas.first?.textoParaCompartir == "Cariño entre versos\n\nVersión independiente con cariño.\nOtro verso.", "El texto compartido incluye el nombre elegido y el poema")
        let antiguaURL = carpeta.appendingPathComponent("antiguas.json")
        let antiguaData = try JSONEncoder().encode([primero, segundo])
        try antiguaData.write(to: antiguaURL)
        let antiguas = CalaveritasStore(urlGuardado: antiguaURL)
        verificar(antiguas.calaveritas.count == 2, "Los poemas sin título de versiones anteriores siguen disponibles")
        verificar(Set(antiguas.calaveritas.map(\.tituloVisible)).count == 2, "La colección antigua obtiene nombres distintos")
        verificar(antiguas.calaveritas.map(\.id) == [primero.id, segundo.id], "La lectura conserva los identificadores antiguos")
        verificar(antiguas.calaveritas.map(\.texto) == [primero.texto, segundo.texto], "No se modifican los poemas antiguos")
        let antiguaTrasLeer = try Data(contentsOf: antiguaURL)
        verificar(antiguaTrasLeer == antiguaData, "Leer el formato antiguo no sobrescribe el archivo")
        verificar(antiguas.nombreSugerido(para: tercero) == "Para Elena · 3", "La sugerencia distingue las versiones anteriores")
        var nombreLargo = perfil
        nombreLargo.nombre = String(repeating: "Ana", count: 60)
        verificar(store.errorNombre(store.nombreSugerido(para: CalaveritaGuardada(para: nombreLargo, texto: "Verso"))) == nil, "Un nombre personal largo no produce una sugerencia inválida")
        ofrendas.eliminarOfrenda(en: IndexSet(integersIn: 0..<ofrendas.ofrendas.count))
        verificar(ofrendas.ofrendasParaCalaveritas.isEmpty, "Al eliminar la ofrenda se bloquea su generación")
        verificar(ofrendas.idOfrendaPrincipal == nil && ofrendas.idModeloPrincipal == OfrendasManager.ofrendaGeneralID, "Eliminar la activa debe restaurar la general")
        verificar(OfrendasManager(urlGuardado: urlPerfiles).idOfrendaPrincipal == nil, "El reinicio no debe recuperar la ofrenda eliminada")

        verificar(CalaveritasStore(urlGuardado: urlPoemas).calaveritas.count == 3, "Eliminar el altar no elimina los poemas guardados")
        verificar(store.calaveritas.allSatisfy { $0.nombrePersona == "Elena" }, "La colección conserva su destinatario original")

        let urlDaniada = carpeta.appendingPathComponent("danado.json")
        let original = Data("{coleccion dañada".utf8)
        try original.write(to: urlDaniada)
        let daniada = CalaveritasStore(urlGuardado: urlDaniada)
        verificar(daniada.mensajeError != nil, "La lectura fallida debe comunicarse")
        verificar(!daniada.guardar(primero, conNombre: "Un recuerdo con tamales"), "No debe sobreescribirse una colección que no pudo leerse")
        let conservado = try Data(contentsOf: urlDaniada)
        verificar(conservado == original, "El archivo original debe conservarse")
        let sinCarpeta = CalaveritasStore(urlGuardado: carpeta.appendingPathComponent("ausente/poemas.json"))
        verificar(!sinCarpeta.guardar(primero, conNombre: "Un recuerdo con tamales") && sinCarpeta.calaveritas.isEmpty, "Un guardado fallido no debe mostrar una confirmación falsa")

        var anterior = primero.texto
        for _ in 0..<300 {
            let otra = CalaveritaGenerator.generar(para: perfil, evitando: anterior)
            verificar(otra != anterior, "Generar otra debe cambiar el poema visible")
            anterior = otra
        }
        perfil.nombre = "Luz * [sitio](https://ejemplo.com)"
        for _ in 0..<30 {
            let poema = CalaveritaGenerator.generar(para: perfil)
            verificar(!poema.contains("https://"), "Los datos personales no deben introducir enlaces Markdown")
        }
        print("CALAVERITAS_OK: \(comprobaciones) comprobaciones")
    }
}
