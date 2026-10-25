//
//  DatosRetratosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct DatosRetratosView: View {
    @Binding var configuracion: ConfiguracionMarcos
    let marcoSeleccionado: MarcoOfrenda
    var mostrarErrorGlobal = false
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach([marcoSeleccionado]) { marco in
                VStack(alignment: .leading, spacing: 10) {
                    Text(marco.numero).font(.headline).foregroundStyle(AppTheme.accent)
                    TextField("Nombre de la persona", text: campo(marco, musica: false), prompt: Text("Nombre de la persona").foregroundStyle(AppTheme.secondaryText))
                        .textInputAutocapitalization(.words).campoRetrato()
                        .accessibilityLabel("Nombre del \(marco.numero.lowercased())")
                        .accessibilityIdentifier("retratos.nombre.\(marco.rawValue)")
                    TextField("Su música o canción favorita", text: campo(marco, musica: true),
                              prompt: Text(configuracion.cantidad == .dos ? "Su música o canción favorita" : "Su música o canción favorita (opcional)").foregroundStyle(AppTheme.secondaryText))
                        .textInputAutocapitalization(.sentences).campoRetrato()
                        .accessibilityLabel("Música del \(marco.numero.lowercased())")
                        .accessibilityIdentifier("retratos.musica.\(marco.rawValue)")
                }
            }
            if let error = mostrarErrorGlobal ? configuracion.errorIdentidad : configuracion.errorIdentidad(en: marcoSeleccionado) {
                Text(error).font(.footnote).foregroundStyle(AppTheme.accent)
            }
            Text("En el altar y en los versos se muestra solo el primer nombre. Los gustos y recuerdos serán compartidos.")
                .font(.footnote).foregroundStyle(AppTheme.secondaryText)
        }
        .padding(18).ofrendaSurface()
    }
    private func campo(_ marco: MarcoOfrenda, musica: Bool) -> Binding<String> {
        Binding(get: { musica ? configuracion.persona(en: marco).musica : configuracion.persona(en: marco).nombre }, set: { valor in
            var persona = configuracion.persona(en: marco)
            if musica { persona.musica = valor } else { persona.nombre = valor }
            configuracion.asignar(persona, en: marco)
        })
    }
}

private extension View {
    func campoRetrato() -> some View {
        textFieldStyle(.plain).foregroundStyle(.white).padding(12)
            .background(Color.white.opacity(0.07), in: .rect(cornerRadius: 12))
    }
}
