//
//  OfrendasManager.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Adolfo G on 21/10/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class OfrendasManager: ObservableObject {
    @Published var ofrendas: [PersonalizacionOfrenda] = []
    @Published private(set) var ofrendasGuardadas: [PersonalizacionOfrenda] = []
    @Published var mensajeError: String?

    /// Los cambios de un formulario todavía abierto no habilitan la generación.
    var ofrendasParaCalaveritas: [PersonalizacionOfrenda] {
        ofrendasGuardadas.filter(\.estaCompleta)
    }
    
    private let urlGuardado: URL
    
    init(urlGuardado: URL? = nil) {
        self.urlGuardado = urlGuardado ?? URL.documentsDirectory.appendingPathComponent("mis_ofrendas.json")
        cargarOfrendas()
    }
    
    @discardableResult
    func agregarOfrenda(_ nuevaOfrenda: PersonalizacionOfrenda) -> Bool {
        guardarOfrendas(ofrendasGuardadas + [nuevaOfrenda])
    }

    @discardableResult
    func actualizarOfrenda(_ ofrenda: PersonalizacionOfrenda) -> Bool {
        guard let indice = ofrendasGuardadas.firstIndex(where: { $0.id == ofrenda.id }) else { return false }
        var actualizadas = ofrendasGuardadas
        actualizadas[indice] = ofrenda
        return guardarOfrendas(actualizadas)
    }

    func eliminarOfrenda(en indices: IndexSet) {
        let ids = Set(indices.compactMap { ofrendas.indices.contains($0) ? ofrendas[$0].id : nil })
        guardarOfrendas(ofrendasGuardadas.filter { !ids.contains($0.id) })
    }

    @discardableResult
    private func guardarOfrendas(_ actualizadas: [PersonalizacionOfrenda]) -> Bool {
        do {
            let datos = try JSONEncoder().encode(actualizadas)
            try datos.write(to: urlGuardado, options: .atomic)
            ofrendas = actualizadas
            ofrendasGuardadas = actualizadas
            mensajeError = nil
            return true
        } catch {
            mensajeError = "No se pudo guardar la ofrenda. Tus datos siguen en el formulario; vuelve a intentarlo."
            return false
        }
    }

    private func cargarOfrendas() {
        guard FileManager.default.fileExists(atPath: urlGuardado.path) else { return }
        do {
            let datos = try Data(contentsOf: urlGuardado)
            let guardadas = try JSONDecoder().decode([PersonalizacionOfrenda].self, from: datos)
            ofrendas = guardadas
            ofrendasGuardadas = guardadas
        } catch {
            print("Error al cargar ofrendas: \(error)")
        }
    }
}
