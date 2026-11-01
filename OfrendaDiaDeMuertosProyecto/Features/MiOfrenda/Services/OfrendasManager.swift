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
    @Published private(set) var idOfrendaPrincipal: UUID?
    @Published private(set) var versionPrincipal = UUID()
    @Published var mensajeErrorSeleccion: String?

    static let ofrendaGeneralID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    var ofrendaPrincipal: PersonalizacionOfrenda? {
        ofrendasGuardadas.first { $0.id == idOfrendaPrincipal }
    }
    var idModeloPrincipal: UUID { ofrendaPrincipal?.id ?? Self.ofrendaGeneralID }


    var ofrendasParaCalaveritas: [PersonalizacionOfrenda] {
        ofrendasGuardadas.filter(\.estaCompleta)
    }
    
    private let urlGuardado: URL
    private let urlSeleccion: URL

    private struct SeleccionPrincipal: Codable { let id: UUID? }
    
    init(urlGuardado: URL? = nil, urlSeleccion: URL? = nil) {
        let perfiles = urlGuardado ?? URL.documentsDirectory.appendingPathComponent("mis_ofrendas.json")
        self.urlGuardado = perfiles
        self.urlSeleccion = urlSeleccion ?? perfiles.deletingLastPathComponent().appendingPathComponent("ofrenda_principal.json")
        cargarOfrendas()
        cargarSeleccionPrincipal()
    }


    @discardableResult
    func seleccionarOfrendaPrincipal(_ id: UUID?) -> Bool {
        guard id == nil || ofrendasGuardadas.contains(where: { $0.id == id }) else {
            mensajeErrorSeleccion = "Esta ofrenda ya no está guardada. Elige otra o vuelve a la ofrenda general."
            return false
        }
        do {
            try guardarSeleccionPrincipal(id)
            if idOfrendaPrincipal != id {
                idOfrendaPrincipal = id
                versionPrincipal = UUID()
            }
            mensajeErrorSeleccion = nil
            return true
        } catch {
            mensajeErrorSeleccion = "No se pudo guardar la elección. La ofrenda anterior sigue seleccionada; vuelve a marcar la que quieras mostrar."
            return false
        }
    }
    
    @discardableResult
    func agregarOfrenda(_ nuevaOfrenda: PersonalizacionOfrenda) -> Bool {
        guardarOfrendas(ofrendasGuardadas + [nuevaOfrenda])
    }

    @discardableResult
    func actualizarOfrenda(_ ofrenda: PersonalizacionOfrenda, actualizarModelo: Bool = true) -> Bool {
        guard let indice = ofrendasGuardadas.firstIndex(where: { $0.id == ofrenda.id }) else { return false }
        var actualizadas = ofrendasGuardadas
        actualizadas[indice] = ofrenda
        let guardada = guardarOfrendas(actualizadas)
        if guardada && actualizarModelo && idOfrendaPrincipal == ofrenda.id { versionPrincipal = UUID() }
        return guardada
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
            if let idOfrendaPrincipal, !actualizadas.contains(where: { $0.id == idOfrendaPrincipal }) {
                self.idOfrendaPrincipal = nil
                versionPrincipal = UUID()
                do { try guardarSeleccionPrincipal(nil) }
                catch { mensajeErrorSeleccion = "Se muestra la ofrenda general porque eliminaste la que estaba elegida. No se pudo guardar esa elección; vuelve a marcar la general." }
            }
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
    private func guardarSeleccionPrincipal(_ id: UUID?) throws {
        let datos = try JSONEncoder().encode(SeleccionPrincipal(id: id))
        try datos.write(to: urlSeleccion, options: .atomic)
    }

    private func cargarSeleccionPrincipal() {
        guard FileManager.default.fileExists(atPath: urlSeleccion.path) else { return }
        do {
            let seleccion = try JSONDecoder().decode(SeleccionPrincipal.self, from: Data(contentsOf: urlSeleccion))
            
            if let id = seleccion.id, ofrendasGuardadas.contains(where: { $0.id == id }) {
                idOfrendaPrincipal = id
            }
        } catch {
            mensajeErrorSeleccion = "No se pudo recuperar la ofrenda elegida. Se muestra la general; vuelve a marcar la que quieras mostrar."
        }
    }

}
