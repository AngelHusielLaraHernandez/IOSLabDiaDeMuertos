//
//  RetratosRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import UIKit

@main struct RetratosRegression {
    @MainActor static func main() async throws {
        var total = 0
        func verificar(_ valor: Bool, _ mensaje: String) { precondition(valor, mensaje); total += 1 }
        let antigua = Data(#"{"cantidad":"dos","principal":"retrato__001"}"#.utf8)
        let cfgAntigua = try JSONDecoder().decode(ConfiguracionMarcos.self, from: antigua)
        verificar(cfgAntigua.personas.isEmpty && cfgAntigua.visibles.count == 2, "La disposición antigua no pierde marcos")
        var perfil = PersonalizacionOfrenda()
        perfil.nombre = "Ana María Lara"; perfil.comidaFavorita = "Tamales"; perfil.musicaFavorita = "Boleros"
        var json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(perfil)) as! [String: Any]
        json.removeValue(forKey: "retratos")
        let legado = try JSONDecoder().decode(PersonalizacionOfrenda.self, from: JSONSerialization.data(withJSONObject: json))
        verificar(legado.estaCompleta && legado.retratos == nil, "El perfil antiguo se conserva y sigue generando")
        verificar(legado.paraCalaverita(marco: nil).nombre == "Ana", "El perfil antiguo solo muestra el primer nombre")
        var cfg = legado.configuracionInicial(desde: cfgAntigua)
        verificar(cfg.persona(en: .izquierdo).nombre == perfil.nombre, "La migración conserva el nombre y su marco")
        verificar(cfg.errorIdentidad != nil, "Dos marcos nuevos requieren los datos del segundo")
        cfg.asignar(IdentidadRetrato(nombre: "Luis Alberto García", musica: "Huapangos"), en: .derecho)
        verificar(cfg.errorIdentidad == nil, "Dos nombres y músicas distintos son válidos")
        var primerPaso = ConfiguracionMarcos()
        primerPaso.asignar(IdentidadRetrato(nombre: "Ana María", musica: "Boleros"), en: .izquierdo)
        verificar(primerPaso.errorIdentidad(en: .izquierdo) == nil, "El marco 1 puede avanzar sin completar todavía el segundo")
        verificar(primerPaso.errorIdentidad != nil, "El conjunto no puede guardarse con el segundo marco pendiente")
        verificar(primerPaso.errorIdentidad(en: .derecho) != nil, "El segundo marco requiere su propia identidad")
        primerPaso.asignar(IdentidadRetrato(nombre: "Luis", musica: "Huapangos"), en: .derecho)
        verificar(primerPaso.errorIdentidad == nil, "Completar el segundo marco habilita gustos y recuerdos")
        var invalida = cfg
        invalida.asignar(IdentidadRetrato(nombre: " ÁNA   MARÍA LARA ", musica: "Rancheras"), en: .derecho)
        verificar(invalida.errorIdentidad != nil, "Mayúsculas y acentos no crean otro nombre")
        invalida = cfg; invalida.asignar(IdentidadRetrato(nombre: "Luis", musica: " BÓLEROS "), en: .derecho)
        verificar(invalida.errorIdentidad != nil, "La música también debe ser diferente")
        invalida = cfg; invalida.asignar(IdentidadRetrato(nombre: "Luis", musica: "  "), en: .derecho)
        verificar(invalida.errorIdentidad != nil, "La segunda música no puede estar vacía")
        var uno = ConfiguracionMarcos(cantidad: .uno, principal: .derecho)
        uno.asignar(IdentidadRetrato(nombre: "Luz"), en: .derecho)
        verificar(uno.errorIdentidad == nil, "Un marco puede omitir música")
        verificar(IdentidadRetrato.primerNombre(de: "  José\nManuel  Pérez ") == "José", "Solo aparece el primer nombre")
        verificar(!IdentidadRetrato.permiteReemplazar(nombreAnterior: "José", nombreNuevo: " JOSE ", esPredeterminada: false), "Cambios cosméticos no permiten reemplazar la foto")
        verificar(!IdentidadRetrato.permiteReemplazar(nombreAnterior: "José", nombreNuevo: " ", esPredeterminada: false), "Borrar el nombre no permite reemplazar")
        verificar(IdentidadRetrato.permiteReemplazar(nombreAnterior: "José", nombreNuevo: "Luis", esPredeterminada: false), "Otro nombre permite reemplazar")
        verificar(IdentidadRetrato.permiteReemplazar(nombreAnterior: "José", nombreNuevo: "José", esPredeterminada: true), "La foto de ejemplo puede sustituirse inicialmente")
        perfil.aplicarRetratos(cfg)
        let ana = perfil.paraCalaverita(marco: .izquierdo), luis = perfil.paraCalaverita(marco: .derecho)
        verificar(ana.nombre == "Ana" && luis.nombre == "Luis", "Cada persona tiene destinatario independiente")
        verificar(ana.musicaFavorita == "Boleros" && luis.musicaFavorita == "Huapangos", "Cada poema usa su música")
        verificar(ana.comidaFavorita == luis.comidaFavorita && ana.aficiones == luis.aficiones, "Los gustos permanecen compartidos")
        for _ in 0..<20 {
            let poema = CalaveritaGenerator.generar(para: luis)
            verificar(poema.contains("**Luis**") && !poema.contains("Alberto"), "El nombre corto aparece resaltado en los versos")
        }
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent("retratos-test-\(UUID())")
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: carpeta) }
        let store = FotosMarcosStore(idOfrenda: UUID(), directorio: carpeta)
        await store.cargar()
        let imagen = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 30)).image { ctx in
            UIColor.orange.setFill(); ctx.fill(CGRect(x: 0, y: 0, width: 20, height: 30))
        }
        verificar(await store.guardarCambios(cfg, imagenes: [.izquierdo: imagen]), "El nombre y la imagen se publican juntos")
        let publicada = store.configuracion
        let manifiesto = carpeta.appendingPathComponent("configuracion.json")
        let datos = try Data(contentsOf: manifiesto)
        verificar(try JSONDecoder().decode(ConfiguracionMarcos.self, from: datos) == publicada, "El manifiesto guarda la misma identidad")
        let fotoURL = carpeta.appendingPathComponent(publicada.archivosFotos[MarcoOfrenda.izquierdo.rawValue]!)
        verificar(FileManager.default.fileExists(atPath: fotoURL.path), "El manifiesto apunta a una imagen existente")
        let recargada = FotosMarcosStore(idOfrenda: UUID(), directorio: carpeta)
        await recargada.cargar()
        verificar(recargada.configuracion == publicada && recargada.fotos[.izquierdo]?.esPredeterminada == false, "Los datos se recuperan al reiniciar")
        verificar(!(await store.guardarCambios(cfg, imagenes: [.izquierdo: imagen])), "El almacén rechaza foto nueva sin cambiar el nombre")
        verificar(try Data(contentsOf: manifiesto) == datos, "Un rechazo no cambia lo guardado")
        var cambio = cfg
        cambio.asignar(IdentidadRetrato(nombre: "Elena Sofía", musica: "Boleros"), en: .izquierdo)
        verificar(await store.guardarCambios(cambio, imagenes: [.izquierdo: imagen]), "Cambiar nombre y foto juntos está permitido")
        verificar(!FileManager.default.fileExists(atPath: fotoURL.path), "Se elimina la versión reemplazada solo después de confirmar")
        let anterior = store.configuracion
        let versionesAntes = try FileManager.default.contentsOfDirectory(atPath: carpeta.path).filter { $0.hasSuffix(".jpg") }.sorted()
        let respaldo = carpeta.appendingPathComponent("respaldo.json")
        try FileManager.default.moveItem(at: manifiesto, to: respaldo)
        try FileManager.default.createDirectory(at: manifiesto, withIntermediateDirectories: false)
        cambio.asignar(IdentidadRetrato(nombre: "Marta", musica: "Boleros"), en: .izquierdo)
        verificar(!(await store.guardarCambios(cambio, imagenes: [.izquierdo: imagen])), "Un fallo de publicación no se confirma")
        verificar(store.configuracion == anterior, "El fallo mantiene la identidad anterior en memoria")
        let versionesDespues = try FileManager.default.contentsOfDirectory(atPath: carpeta.path).filter { $0.hasSuffix(".jpg") }.sorted()
        verificar(versionesDespues == versionesAntes, "El fallo elimina únicamente sus imágenes nuevas")
        verificar(store.mensajeError != nil, "El fallo ofrece un mensaje para reintentar")
        let carpetaGeneral = carpeta.appendingPathComponent("general")
        try FileManager.default.createDirectory(at: carpetaGeneral, withIntermediateDirectories: true)
        var configuracionGeneralAnterior = uno
        configuracionGeneralAnterior.archivosFotos = [:]
        try JSONEncoder().encode(configuracionGeneralAnterior).write(to: carpetaGeneral.appendingPathComponent("configuracion.json"))
        let general = FotosMarcosStore(idOfrenda: OfrendasManager.ofrendaGeneralID, directorio: carpetaGeneral)
        await general.cargar()
        verificar(!general.requiereIdentidad, "La general no debe pedir nombres ni música")
        verificar(general.configuracion.visibles == [.derecho], "La general conserva la elección anterior de un marco")
        verificar(general.configuracion.personas.isEmpty, "La general no conserva identidades de personalización")
        verificar(await general.guardarCambios(ConfiguracionMarcos(), imagenes: [.izquierdo: imagen]), "La general permite guardar una fotografía sin nombre")
        verificar(await general.guardarCambios(ConfiguracionMarcos(), imagenes: [.izquierdo: imagen]), "La general permite reemplazar una fotografía sin renombrar")
        verificar(general.configuracion.visibles.count == 2 && general.configuracion.personas.isEmpty, "Guardar mantiene dos marcos sin identidades en la general")
        var unMarcoGeneral = general.configuracion
        unMarcoGeneral.cantidad = .uno
        unMarcoGeneral.principal = .izquierdo
        verificar(await general.guardarCambios(unMarcoGeneral), "La general permite guardar un marco sin nombres")
        let generalRecuperada = FotosMarcosStore(idOfrenda: OfrendasManager.ofrendaGeneralID, directorio: carpetaGeneral)
        await generalRecuperada.cargar()
        verificar(generalRecuperada.configuracion.visibles == [.izquierdo], "Un marco general persiste al reiniciar")
        var ambosGenerales = generalRecuperada.configuracion
        ambosGenerales.cantidad = .dos
        verificar(await generalRecuperada.guardarCambios(ambosGenerales), "La general puede volver a mostrar ambas fotografías")
        verificar(generalRecuperada.configuracion.visibles.count == 2 && generalRecuperada.fotos[.izquierdo] != nil, "Cambiar la cantidad conserva las imágenes")
        verificar(store.requiereIdentidad, "Una personalizada mantiene sus validaciones de identidad")
        print("RETRATOS_OK: \(total) comprobaciones")
    }
}
