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
        versionGuardada(de: calaverita) != nil
    }

    func versionGuardada(de calaverita: CalaveritaGuardada) -> CalaveritaGuardada? {
        calaveritas.first { $0.idOfrenda == calaverita.idOfrenda && $0.texto == calaverita.texto }
    }


    @discardableResult
    func guardar(_ calaverita: CalaveritaGuardada, conNombre nombre: String) -> Bool {
        guard lecturaValida else {
            mensajeError = "No pudimos leer tu colección. Vuelve a abrir Guardadas para reintentar. Conservamos el archivo original."
            return false
        }
        guard !contiene(calaverita) else { mensajeError = nil; return true }
        if let error = errorNombre(nombre) {
            mensajeError = error
            return false
        }
        var nombrada = calaverita
        nombrada.titulo = Self.limpiarNombre(nombre)
        do {
            let actualizadas = [nombrada] + calaveritas
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

    func nombreSugerido(para calaverita: CalaveritaGuardada) -> String {
        let base = String("Para \(calaverita.nombrePersona)".prefix(70))
        var nombre = base
        var numero = 2
        while calaveritas.contains(where: { Self.claveNombre($0.tituloVisible) == Self.claveNombre(nombre) }) {
            nombre = "\(base) · \(numero)"; numero += 1
        }
        return nombre
    }

    func errorNombre(_ nombre: String) -> String? {
        let limpio = Self.limpiarNombre(nombre)
        if limpio.isEmpty { return "Escribe un nombre para guardar tu calaverita." }
        if limpio.count > 80 { return "Usa un nombre de hasta 80 caracteres." }
        if calaveritas.contains(where: { Self.claveNombre($0.tituloVisible) == Self.claveNombre(limpio) }) {
            return "Ya tienes una calaverita con ese nombre. Elige otro para distinguirlas."
        }
        return nil
    }

    private static func limpiarNombre(_ nombre: String) -> String {
        nombre.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
    }

    private static func claveNombre(_ nombre: String) -> String {
        limpiarNombre(nombre).folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "es_MX"))
    }

    func cargar() {
        do {
            let datos = try Data(contentsOf: urlGuardado)
            let leidas = try JSONDecoder().decode([CalaveritaGuardada].self, from: datos)
            // Los archivos antiguos no tenían título. Se distinguen al leerlos, sin escribir el archivo.
            var ocupados = Set(leidas.compactMap(\.titulo).map(Self.claveNombre))
            calaveritas = leidas.map { poema in
                guard poema.titulo?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != false else { return poema }
                var recuperada = poema
                let base = "Para \(poema.nombrePersona)"
                var titulo = base
                var numero = 2
                while ocupados.contains(Self.claveNombre(titulo)) {
                    titulo = "\(base) · \(numero)"; numero += 1
                }
                recuperada.titulo = titulo
                ocupados.insert(Self.claveNombre(titulo))
                return recuperada
            }
            lecturaValida = true
            mensajeError = nil
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            calaveritas = []
            lecturaValida = true
            mensajeError = nil
        } catch {

            lecturaValida = false
            mensajeError = "No se pudieron leer tus calaveritas guardadas. Puedes volver a intentarlo; el archivo se conserva."
        }
    }
}
