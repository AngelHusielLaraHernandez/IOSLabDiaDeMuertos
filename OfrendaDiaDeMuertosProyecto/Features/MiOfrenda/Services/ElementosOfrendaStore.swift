//
//  ElementosOfrendaStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import Observation


@MainActor @Observable
final class ElementosOfrendaStore {
    let idOfrenda: UUID
    

    
    private(set) var configuracion = ConfiguracionElementosOfrenda()
    private(set) var cargando = false
    private(set) var guardando = false
    var mensajeError: String?
    private var haCargado = false
    private var revision = 0
    private var escritura: Task<Void, Never>?
    private let archivos: ArchivoElementosOfrenda


        init(idOfrenda: UUID) {
            self.idOfrenda = idOfrenda
            
     
            let urlArchivo: URL = {
                let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                return applicationSupport.appendingPathComponent("OfrendaPersonalizada").appendingPathComponent("\(idOfrenda.uuidString)_elementos.json")
            }()
            
       
            self.archivos = ArchivoElementosOfrenda(archivo: urlArchivo)
            
            
            Task {
                await self.cargar()
            }
        }
    
    
    func cargar() async {
        guard !haCargado, !cargando else { return }
        cargando = true
        defer { cargando = false; haCargado = true }
        do {
            if let data = try await archivos.cargar() {
                configuracion = try JSONDecoder().decode(ConfiguracionElementosOfrenda.self, from: data)
            }
        } catch {
            mensajeError = "No se pudo recuperar la selección de elementos. Se muestra el altar completo; puedes volver a elegir sus objetos."
        }
    }

    func establecer(_ grupo: GrupoElementoOfrenda, visible: Bool) {
        guard haCargado, !cargando, configuracion.muestra(grupo) != visible else { return }
        var nueva = configuracion
        nueva.establecer(grupo, visible: visible)
        guardar(nueva)
    }

    func mostrarTodos() {
        guard haCargado, !cargando else { return }
        guardar(ConfiguracionElementosOfrenda())
    }

    func reintentarGuardado() { guardar(configuracion, forzar: true) }
    func esperarGuardado() async { await escritura?.value }

    private func guardar(_ nueva: ConfiguracionElementosOfrenda, forzar: Bool = false) {
        guard forzar || nueva != configuracion else { return }
        configuracion = nueva
        revision += 1
        let numero = revision
        guardando = true
        escritura?.cancel()
        escritura = Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let data = try JSONEncoder().encode(nueva)
                try Task.checkCancellation()
                try await archivos.guardar(data, revision: numero)
                if revision == numero { guardando = false }
            } catch is CancellationError { } catch {
                guard revision == numero else { return }
                guardando = false
                mensajeError = "La selección se ve en esta sesión, pero no se pudo guardar en el teléfono. Intenta guardarla de nuevo."
            }
        }
    }
}


private actor ArchivoElementosOfrenda {
    private let archivo: URL?
    private var ultimaRevision = 0
    init(archivo: URL?) { self.archivo = archivo }
    private func ubicacion() throws -> URL {
        if let archivo { return archivo }
        return try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                           appropriateFor: nil, create: true)
            .appendingPathComponent("OfrendaPersonalizada", isDirectory: true)
            .appendingPathComponent("elementos.json")
    }
    func cargar() throws -> Data? {
        let url = try ubicacion()
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    func guardar(_ data: Data, revision: Int) throws {
        guard revision >= ultimaRevision else { return }
        let url = try ubicacion()
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url, options: .atomic)
        ultimaRevision = revision
    }
}
