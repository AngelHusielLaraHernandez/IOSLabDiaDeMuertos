//
//  FotosMarcosStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 17/10/26.
//

import Foundation
import Observation
import UIKit


/// Una sola fuente de fotos para la pantalla principal, la propuesta y el Canvas.
@MainActor @Observable
final class FotosMarcosStore {
    let idOfrenda: UUID
    
    private(set) var fotos: [MarcoOfrenda: FotoMarco]
    private(set) var cargando = false
    private(set) var guardandoConfiguracion = false
    private(set) var configuracion = ConfiguracionMarcos()
    var mensajeError: String?
    private let predeterminadas: [MarcoOfrenda: FotoMarco]
    private var haCargado = false
    private let archivos: ArchivoFotosMarcos // Ya no lo inicializamos aquí directamente

    init(idOfrenda: UUID) {
        self.idOfrenda = idOfrenda
        // Inicializamos el actor pasándole el ID para que sepa en qué carpeta guardar
        self.archivos = ArchivoFotosMarcos(idOfrenda: idOfrenda)
        
        let ejemplos = Self.cargarEjemplos()
        self.predeterminadas = ejemplos
        self.fotos = ejemplos
        
        Task {
            await cargar()
        }
    }
    
    func cargar() async {
        guard !haCargado, !cargando else { return }
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
            fotos = recuperadas
            haCargado = true
        } catch {
            mensajeError = "No se pudieron recuperar las fotos o la disposición. Se conservan los ajustes de ejemplo."
        }
    }

    @discardableResult
    func guardar(_ imagen: UIImage, en marco: MarcoOfrenda) async -> Bool {
        guard let data = imagen.jpegData(compressionQuality: 0.9) else {
            mensajeError = "No se pudo preparar la fotografía. Intenta elegirla de nuevo."
            return false
        }
        do {
            try await archivos.guardar(data, nombre: marco.rawValue)
            fotos[marco] = FotoMarco(imagen: imagen)
            return true
        } catch {
            mensajeError = "No se pudo guardar la foto en este teléfono. La foto anterior se conserva."
            return false
        }
    }

    func restablecer(_ marco: MarcoOfrenda) async {
        do {
            try await archivos.guardar(nil, nombre: marco.rawValue)
            fotos[marco] = predeterminadas[marco]
        } catch {
            mensajeError = "No se pudo restablecer la fotografía. Intenta de nuevo."
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

/// El acceso al disco se hace fuera del actor de la interfaz.
private actor ArchivoFotosMarcos {
    let idOfrenda: UUID // Agregamos el ID aquí también
    
    init(idOfrenda: UUID) {
        self.idOfrenda = idOfrenda
    }
    
    private var carpeta: URL {
        get throws {
            try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                        appropriateFor: nil, create: true)
                .appendingPathComponent("FotosMarcos", isDirectory: true)
                // AHORA SÍ creará una subcarpeta única por cada ofrenda
                .appendingPathComponent(idOfrenda.uuidString, isDirectory: true)
        }
    }

    func cargar() throws -> [String: Data] {
        let carpeta = try carpeta
        var resultado: [String: Data] = [:]
        for nombre in ["retrato__001", "retrato__002"] {
            let url = carpeta.appendingPathComponent(nombre).appendingPathExtension("jpg")
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
