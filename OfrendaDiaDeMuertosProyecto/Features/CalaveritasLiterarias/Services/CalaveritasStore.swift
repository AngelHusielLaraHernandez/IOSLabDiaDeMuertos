//
//  CalaveritasStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import Combine

@MainActor
final class CalaveritasStore: ObservableObject {
    @Published private(set) var calaveritas: [CalaveritaGuardada] = []
    @Published var mensajeError: String?
    private let urlGuardado: URL
    private var lecturaValida = false

    init(urlGuardado: URL? = nil) {
        self.urlGuardado = urlGuardado ?? URL.documentsDirectory.appendingPathComponent("mis_calaveritas.json")
        cargar()
    }

    func contiene(_ calaverita: CalaveritaGuardada) -> Bool {
        calaveritas.contains { $0.idOfrenda == calaverita.idOfrenda && $0.texto == calaverita.texto }
    }

    /// La interfaz confirma el guardado únicamente después de escribir el archivo completo.
    @discardableResult
    func guardar(_ calaverita: CalaveritaGuardada) -> Bool {
        guard lecturaValida else {
            mensajeError = "No pudimos leer tu colección. Vuelve a abrir Guardadas para reintentar. Conservamos el archivo original."
            return false
        }
        guard !contiene(calaverita) else { return true }
        do {
            let actualizadas = [calaverita] + calaveritas
            let datos = try JSONEncoder().encode(actualizadas)
            try datos.write(to: urlGuardado, options: .atomic)
            calaveritas = actualizadas
            mensajeError = nil
            return true
        } catch {
            mensajeError = "No se pudo guardar la calaverita. El poema sigue aquí; intenta guardarlo de nuevo."
            return false
        }
    }

    func cargar() {
        do {
            let datos = try Data(contentsOf: urlGuardado)
            calaveritas = try JSONDecoder().decode([CalaveritaGuardada].self, from: datos)
            lecturaValida = true
            mensajeError = nil
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            calaveritas = []
            lecturaValida = true
            mensajeError = nil
        } catch {
            // Un archivo ilegible nunca se reemplaza con una colección vacía.
            lecturaValida = false
            mensajeError = "No se pudieron leer tus calaveritas guardadas. Puedes volver a intentarlo; el archivo se conserva."
        }
    }
}
