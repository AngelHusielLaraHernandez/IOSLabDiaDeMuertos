//
//  GuiaOfrendaStore.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import Combine

/// Completar u omitir persiste; interrumpir la app a mitad no descarta la ayuda.
@MainActor
final class GuiaOfrendaStore: ObservableObject {
    static let claveCompletada = "ofrenda.guiaInicial.v1.completada"
    @Published private(set) var paso: PasoGuiaOfrenda?
    @Published private(set) var altarDisponible = false
    private let defaults: UserDefaults
    private var pendiente: Bool
    var activa: Bool { paso != nil }
    var completada: Bool { defaults.bool(forKey: Self.claveCompletada) }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        pendiente = !defaults.bool(forKey: Self.claveCompletada)
    }

    func actualizarDisponibilidad(_ disponible: Bool) {
        if altarDisponible != disponible { altarDisponible = disponible }
        if disponible, pendiente, paso == nil {
            pendiente = false
            paso = .explorar
        }
    }

    func siguiente() {
        guard let paso else { return }
        if paso.esUltimo { terminar() }
        else { self.paso = PasoGuiaOfrenda(rawValue: paso.rawValue + 1) }
    }

    func anterior() {
        guard let paso, paso.rawValue > 0 else { return }
        self.paso = PasoGuiaOfrenda(rawValue: paso.rawValue - 1)
    }

    func terminar() {
        defaults.set(true, forKey: Self.claveCompletada)
        pendiente = false
        paso = nil
    }

    func repetir() {
        GuiaContextualStore.reiniciarAyudas(defaults: defaults)
        // La preferencia previa se conserva; repetir no provoca otra guía en el próximo inicio.
        paso = nil
        pendiente = true
        if altarDisponible { actualizarDisponibilidad(true) }
    }
}
