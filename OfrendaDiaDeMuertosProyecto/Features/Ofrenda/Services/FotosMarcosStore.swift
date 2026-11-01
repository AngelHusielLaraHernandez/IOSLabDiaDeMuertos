//
//  FotosMarcosStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import Foundation
import Observation
import UIKit


@MainActor @Observable
final class FotosMarcosStore {
    let idOfrenda: UUID
    var requiereIdentidad: Bool { idOfrenda != OfrendasManager.ofrendaGeneralID }
    
    private(set) var fotos: [MarcoOfrenda: FotoMarco]
    private(set) var cargando = false
    private(set) var guardandoConfiguracion = false
    private(set) var configuracion = ConfiguracionMarcos()
    var mensajeError: String?
    private let predeterminadas: [MarcoOfrenda: FotoMarco]
    private var haCargado = false
    private var fotosPersonalesGuardadas: Set<MarcoOfrenda> = []
    private let archivos: ArchivoFotosMarcos // Ya no lo inicializamos aquí directamente

    init(idOfrenda: UUID, directorio: URL? = nil) {
        self.idOfrenda = idOfrenda
        // Inicializamos el actor pasándole el ID para que sepa en qué carpeta guardar
        self.archivos = ArchivoFotosMarcos(idOfrenda: idOfrenda, directorio: directorio)
        
        let ejemplos = Self.cargarEjemplos()
        self.predeterminadas = ejemplos
        self.fotos = ejemplos
        
        Task {
            await cargar()
        }
    }
    
    func cargar() async {
        guard !haCargado else { return }
        if cargando {
            while cargando && !Task.isCancelled { try? await Task.sleep(for: .milliseconds(10)) }
            return
        }
        cargando = true
        defer { cargando = false }
        do {
            let datos = try await archivos.cargar()
            let configuracionGuardada = try await archivos.cargarConfiguracion()
            var recuperadas = predeterminadas
            for marco in MarcoOfrenda.allCases {
                if let data = datos[marco.rawValue], let cgImage = PhotoProcessor.thumbnail(from: data, maxPixelSize: 1024) {
                    recuperadas[marco] = FotoMarco(imagen: UIImage(cgImage: cgImage))
                }
            }
            if let configuracionGuardada {
                configuracion = try JSONDecoder().decode(ConfiguracionMarcos.self, from: configuracionGuardada)
            }
            if !requiereIdentidad {
                configuracion.personas = [:]
            }
            fotosPersonalesGuardadas = Set(recuperadas.filter { !$0.value.esPredeterminada }.map(\.key))
            fotos = recuperadas
            haCargado = true
        } catch {
            mensajeError = "No se pudieron recuperar las fotos o la disposición. Se conservan los ajustes de ejemplo."
        }
    }

    func esPredeterminadaGuardada(_ marco: MarcoOfrenda) -> Bool { !fotosPersonalesGuardadas.contains(marco) }

    func previsualizar(_ imagen: UIImage, en marco: MarcoOfrenda) { fotos[marco] = FotoMarco(imagen: imagen) }

    @discardableResult
    func guardarCambios(_ propuesta: ConfiguracionMarcos, imagenes: [MarcoOfrenda: UIImage] = [:], nombresAnteriores: [MarcoOfrenda: String] = [:]) async -> Bool {
        guard haCargado, !cargando, !guardandoConfiguracion else { mensajeError = "Espera a que se recuperen las fotografías antes de guardar."; return false }
        guard !requiereIdentidad || imagenes.keys.allSatisfy({ marco in
            IdentidadRetrato.permiteReemplazar(nombreAnterior: configuracion.persona(en: marco).nombre.isEmpty ? nombresAnteriores[marco] ?? "" : configuracion.persona(en: marco).nombre,
                nombreNuevo: propuesta.persona(en: marco).nombre, esPredeterminada: esPredeterminadaGuardada(marco))
        }) else { mensajeError = "Para reemplazar la fotografía cambia también el nombre de esa persona."; return false }
        if requiereIdentidad, let error = propuesta.errorIdentidad { mensajeError = error; return false }
        guardandoConfiguracion = true
        defer { guardandoConfiguracion = false }
        var nueva = propuesta
        if !requiereIdentidad { nueva.personas = [:] }
        nueva.archivosFotos = configuracion.archivosFotos
        var archivosNuevos: [String: Data] = [:]
        for (marco, imagen) in imagenes {
            guard let datos = imagen.jpegData(compressionQuality: 0.9) else { mensajeError = "No se pudo preparar la fotografía."; return false }
            let nombre = "\(marco.rawValue)_\(UUID().uuidString).jpg"
            nueva.archivosFotos[marco.rawValue] = nombre
            archivosNuevos[nombre] = datos
        }
        do {
            try await archivos.confirmar(archivosNuevos, configuracion: JSONEncoder().encode(nueva))
            configuracion = nueva
            for (marco, imagen) in imagenes { fotos[marco] = FotoMarco(imagen: imagen); fotosPersonalesGuardadas.insert(marco) }
            mensajeError = nil
            return true
        } catch {
            mensajeError = "No se pudieron guardar las fotos y sus nombres. Se conserva la versión anterior; vuelve a intentarlo."
            return false
        }
    }

    @discardableResult
    func configurar(_ nueva: ConfiguracionMarcos) async -> Bool {
        guard !cargando, !guardandoConfiguracion else { return false }
        guard nueva != configuracion else { return true }
        guardandoConfiguracion = true
        defer { guardandoConfiguracion = false }
        do {
            let datos = try JSONEncoder().encode(nueva)
            try await archivos.guardarConfiguracion(datos)
            configuracion = nueva
            return true
        } catch {
            mensajeError = "No se pudo guardar la disposición de los marcos. Intenta de nuevo."
            return false
        }
    }

    private static func cargarEjemplos() -> [MarcoOfrenda: FotoMarco] {
        var resultado: [MarcoOfrenda: FotoMarco] = [:]
        for marco in MarcoOfrenda.allCases {
            let nombre = marco == .izquierdo ? "RetratoIzquierdo" : "RetratoDerecho"
            guard let url = Bundle.main.url(forResource: nombre, withExtension: "png"),
                  let data = try? Data(contentsOf: url),
                  let thumbnail = PhotoProcessor.thumbnail(from: data, maxPixelSize: 1024) else { continue }
            let imagen = UIImage(cgImage: thumbnail)
            let ratio = marco.relacionAspecto
            // CORRECCIÓN AQUÍ: Se añade el asterisco para multiplicar
            let size = CGSize(width: 1024 * ratio, height: 1024)
            let rect = PhotoCropGeometry.imageRect(image: imagen.size, viewport: size, zoom: 1, offset: .zero)
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            format.opaque = true
            format.preferredRange = .standard
            let ajustada = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                imagen.draw(in: rect)
            }
            resultado[marco] = FotoMarco(imagen: ajustada, esPredeterminada: true)
        }
        return resultado
    }
}


private actor ArchivoFotosMarcos {
    let idOfrenda: UUID
    let directorio: URL?
    init(idOfrenda: UUID, directorio: URL? = nil) {
        self.idOfrenda = idOfrenda
        self.directorio = directorio
    }
    
    private var carpeta: URL {
        get throws {
            if let directorio { return directorio }
            return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                        appropriateFor: nil, create: true)
                .appendingPathComponent("FotosMarcos", isDirectory: true)
                .appendingPathComponent(idOfrenda.uuidString, isDirectory: true)
        }
    }

    func cargar() throws -> [String: Data] {
        let carpeta = try carpeta
        var resultado: [String: Data] = [:]
        let configuracion = try cargarConfiguracion()
        let objeto = configuracion.flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: Any] }
        let archivos = objeto?["archivosFotos"] as? [String: String] ?? [:]
        for nombre in ["retrato__001", "retrato__002"] {
            let archivo = archivos[nombre] ?? "\(nombre).jpg"
            guard archivo == (archivo as NSString).lastPathComponent else { continue }
            let url = carpeta.appendingPathComponent(archivo)
            if FileManager.default.fileExists(atPath: url.path) {
                resultado[nombre] = try Data(contentsOf: url)
            }
        }
        return resultado
    }

    func cargarConfiguracion() throws -> Data? {
        let url = try carpeta.appendingPathComponent("configuracion.json")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    func confirmar(_ imagenes: [String: Data], configuracion: Data) throws {
        let carpeta = try carpeta
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        var creados: [URL] = []
        do {
            for (nombre, datos) in imagenes {
                let url = carpeta.appendingPathComponent(nombre)
                try datos.write(to: url, options: .atomic)
                creados.append(url)
            }
            try configuracion.write(to: carpeta.appendingPathComponent("configuracion.json"), options: .atomic)
        } catch {
            for url in creados { try? FileManager.default.removeItem(at: url) }
            throw error
        }
        let objeto = (try? JSONSerialization.jsonObject(with: configuracion)) as? [String: Any]
        let vigentes = Set((objeto?["archivosFotos"] as? [String: String] ?? [:]).values)
        for url in (try? FileManager.default.contentsOfDirectory(at: carpeta, includingPropertiesForKeys: nil)) ?? [] {
            let nombre = url.lastPathComponent
            if nombre.hasPrefix("retrato__"), nombre.hasSuffix(".jpg"), !vigentes.contains(nombre),
               vigentes.contains(where: { $0.hasPrefix(String(nombre.prefix(12))) }) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }

    func guardarConfiguracion(_ datos: Data) throws {
        let carpeta = try carpeta
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        try datos.write(to: carpeta.appendingPathComponent("configuracion.json"), options: .atomic)
    }

    func guardar(_ datos: Data?, nombre: String) throws {
        let carpeta = try carpeta
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        let url = carpeta.appendingPathComponent(nombre).appendingPathExtension("jpg")
        if let datos {
            try datos.write(to: url, options: .atomic)
        } else if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
