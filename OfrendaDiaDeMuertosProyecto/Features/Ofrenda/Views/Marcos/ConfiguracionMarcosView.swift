//
//  ConfiguracionMarcosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct ConfiguracionMarcosView: View {
    let store: FotosMarcosStore
    var marcoSugerido: MarcoOfrenda?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Marcos en tu ofrenda")
                .font(.headline)
            Picker("Cantidad de marcos", selection: Binding(
                get: { store.configuracion.cantidad },
                set: { cantidad in
                    var nueva = store.configuracion
                    nueva.cantidad = cantidad
                    if cantidad == .uno, let marcoSugerido { nueva.principal = marcoSugerido }
                    guardar(nueva)
                }
            )) {
                ForEach(CantidadMarcos.allCases, id: \.self) { cantidad in
                    Text(cantidad.titulo).tag(cantidad)
                }
            }
            .pickerStyle(.segmented)
            if store.configuracion.cantidad == .uno {
                Picker("Fotografía que se conserva visible", selection: Binding(
                    get: { store.configuracion.principal },
                    set: { marco in
                        var nueva = store.configuracion
                        nueva.principal = marco
                        guardar(nueva)
                    }
                )) {
                    ForEach(MarcoOfrenda.allCases) { marco in
                        Text(marco.titulo).tag(marco)
                    }
                }
                .tint(AppTheme.accent)
                Text("Este marco quedará al centro. La otra foto se conserva por si después quieres mostrar ambos.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            if store.guardandoConfiguracion { ProgressView("Guardando disposición…") }
        }
        .padding(16)
        .ofrendaSurface()
        .disabled(store.cargando || store.guardandoConfiguracion)
    }

    private func guardar(_ configuracion: ConfiguracionMarcos) {
        Task { await store.configurar(configuracion) }
    }
}
