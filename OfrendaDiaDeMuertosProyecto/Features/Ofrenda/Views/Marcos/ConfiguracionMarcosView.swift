//
//  ConfiguracionMarcosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

/// Elige la cantidad y toca directamente el retrato que se va a editar.
struct ConfiguracionMarcosView: View {
    let store: FotosMarcosStore
    @Binding var marcoElegido: MarcoOfrenda
    var bloqueado = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Picker("Cantidad de marcos", selection: Binding(
                get: { store.configuracion.cantidad },
                set: { cantidad in
                    var nueva = store.configuracion
                    nueva.cantidad = cantidad
                    if cantidad == .uno { nueva.principal = marcoElegido }
                    guardar(nueva)
                }
            )) {
                ForEach(CantidadMarcos.allCases, id: \.self) { cantidad in
                    Text(cantidad.titulo).tag(cantidad)
                }
            }
            .pickerStyle(.segmented)
            Text(store.configuracion.cantidad == .dos ? "Toca el retrato que quieres editar." : "Este retrato aparecerá al centro de tu ofrenda.")
                .font(.subheadline).foregroundStyle(AppTheme.secondaryText)
            HStack(alignment: .top, spacing: 18) {
                ForEach(store.configuracion.visibles) { marco in
                    Button { marcoElegido = marco } label: {
                        VStack(spacing: 10) {
                            retrato(marco)
                            VStack(spacing: 3) {
                                Text(marco.numero).font(.subheadline.bold())
                                Text(marco == .izquierdo ? "Izquierdo" : "Derecho")
                                    .font(.caption).foregroundStyle(AppTheme.secondaryText)
                            }
                        }
                        .frame(maxWidth: store.configuracion.cantidad == .uno ? 200 : 160)
                        .frame(maxWidth: .infinity)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Editar \(marco.numero.lowercased()), \(marco.titulo.lowercased())")
                    .accessibilityAddTraits(marcoElegido == marco ? .isSelected : [])
                }
            }
            if store.configuracion.cantidad == .uno {
                Menu {
                    ForEach(MarcoOfrenda.allCases) { marco in
                        Button {
                            var nueva = store.configuracion
                            nueva.principal = marco
                            guardar(nueva)
                        } label: {
                            Label("\(marco.numero) · \(marco.titulo)", systemImage: marco == store.configuracion.principal ? "checkmark.circle.fill" : "circle")
                        }
                    }
                } label: {
                    Label("Usar la fotografía del otro marco", systemImage: "arrow.left.arrow.right")
                        .font(.caption.weight(.semibold)).frame(maxWidth: .infinity)
                }
                .ofrendaSecondaryAction()
            }
            Label("Editando: \(marcoElegido.numero) · \(marcoElegido.titulo)", systemImage: "pencil.circle.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier("marcoEnEdicion")
            if store.guardandoConfiguracion {
                ProgressView("Guardando disposición…").frame(maxWidth: .infinity)
            }
        }
        .padding(18)
        .ofrendaSurface()
        .disabled(bloqueado || store.cargando || store.guardandoConfiguracion)
        .onChange(of: store.configuracion) { _, nueva in
            if !nueva.visibles.contains(marcoElegido) { marcoElegido = nueva.principal }
        }
        .onAppear {
            if !store.configuracion.visibles.contains(marcoElegido) { marcoElegido = store.configuracion.principal }
        }
    }

    private func retrato(_ marco: MarcoOfrenda) -> some View {
        let seleccionado = marcoElegido == marco
        return ZStack(alignment: .topTrailing) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(AppTheme.background)
                if let foto = store.fotos[marco] {
                    Image(uiImage: foto.imagen).resizable().scaledToFill()
                } else {
                    Image(systemName: "person.crop.rectangle").font(.largeTitle).foregroundStyle(AppTheme.secondaryText)
                }
            }
            .aspectRatio(marco.relacionAspecto, contentMode: .fit)
            .clipShape(.rect(cornerRadius: 10))
            .padding(7)
            .background(seleccionado ? AppTheme.accent.opacity(0.22) : Color.white.opacity(0.06), in: .rect(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(seleccionado ? AppTheme.accent : .white.opacity(0.18), lineWidth: seleccionado ? 2.5 : 1))
            Image(systemName: seleccionado ? "checkmark.circle.fill" : "circle")
                .font(.title3).symbolRenderingMode(.palette)
                .foregroundStyle(seleccionado ? AppTheme.accent : .white.opacity(0.65), AppTheme.background)
                .padding(12)
        }
        .accessibilityHidden(true)
    }

    private func guardar(_ configuracion: ConfiguracionMarcos) {
        Task {
            if await store.configurar(configuracion), configuracion.cantidad == .uno {
                marcoElegido = configuracion.principal
            }
        }
    }
}
