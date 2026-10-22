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
    
    private let urlGuardado: URL = {
        let rutas = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return rutas[0].appendingPathComponent("mis_ofrendas.json")
    }()
    
    init() {
        cargarOfrendas()
    }
    
    func agregarOfrenda(_ nuevaOfrenda: PersonalizacionOfrenda) {
        ofrendas.append(nuevaOfrenda)
        guardarOfrendas()
    }
    
    func actualizarOfrenda(_ ofrenda: PersonalizacionOfrenda) {
        if let indice = ofrendas.firstIndex(where: { $0.id == ofrenda.id }) {
            ofrendas[indice] = ofrenda
            guardarOfrendas()
        }
    }
    
    func eliminarOfrenda(en indices: IndexSet) {
        // Opcional: Aquí podrías añadir lógica para borrar las carpetas de fotos asociadas al ID
        ofrendas.remove(atOffsets: indices)
        guardarOfrendas()
    }
    
    private func guardarOfrendas() {
        do {
            let datos = try JSONEncoder().encode(ofrendas)
            try datos.write(to: urlGuardado, options: .atomic)
        } catch {
            print("Error al guardar ofrendas: \(error)")
        }
    }
    
    private func cargarOfrendas() {
        guard FileManager.default.fileExists(atPath: urlGuardado.path) else { return }
        do {
            let datos = try Data(contentsOf: urlGuardado)
            ofrendas = try JSONDecoder().decode([PersonalizacionOfrenda].self, from: datos)
        } catch {
            print("Error al cargar ofrendas: \(error)")
        }
    }
}
