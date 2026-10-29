//
//  CalendarioOfrendaView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import UIKit


struct CalendarioOfrendaView: View {
    let activo: Bool
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var revision = Date()
    @Binding var mostrarFechas: Bool

    var body: some View {
        Group {
            if activo && scenePhase == .active {
                TimelineView(.periodic(from: revision, by: 60)) { contexto in
                    contenido(fecha: contexto.date)
                }
            } else {
                contenido(fecha: revision)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in revision = Date() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in revision = Date() }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in revision = Date() }
        .onChange(of: scenePhase) { _, fase in if fase == .active { revision = Date() } }
        .onChange(of: activo) { _, valor in if valor { revision = Date() } }
        .sheet(isPresented: $mostrarFechas) {
            FechasMuertosView().ofrendaSheet(detents: UserDefaults.standard.bool(forKey: GuiaContextualAmbito.fechas.clave) ? [.medium, .large] : [.large])
        }
    }

    private func contenido(fecha: Date) -> some View {
        Button { mostrarFechas = true } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label("Días para volver a recordar", systemImage: "calendar")
                        .font(.caption.weight(.semibold))
                    Spacer(minLength: 4)
                    Image(systemName: "info.circle").font(.caption)
                }.foregroundStyle(AppTheme.secondaryText)
                let disposicion = dynamicTypeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 10)) : AnyLayout(HStackLayout(alignment: .top, spacing: 8))
                disposicion {
                    ForEach(ConmemoracionMuertos.allCases) { dia in
                        let cuenta = dia.cuenta(desde: fecha)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(dia.nombre).font(.caption2).foregroundStyle(AppTheme.secondaryText)
                            Text(cuenta.texto).font(.subheadline.bold()).monospacedDigit().foregroundStyle(AppTheme.accent)
                            Text(dia.fechaCorta + (cuenta.esSiguienteAno ? " · \(String(cuenta.ano))" : ""))
                                .font(.caption2).foregroundStyle(AppTheme.secondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(dia.nombre), \(cuenta.texto), \(dia.fechaCorta) de \(String(cuenta.ano))")
                    }
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.surface.opacity(0.55), in: .rect(cornerRadius: 16))
            .contentShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Consulta las fechas y su fuente cultural")
        .accessibilityIdentifier("ofrenda.calendario")
    }
}

private struct FechasMuertosView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Un lugar para cada recuerdo").font(.title2.bold())
                    ForEach(ConmemoracionMuertos.allCases) { dia in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: dia.simbolo).foregroundStyle(AppTheme.accent).frame(width: 28)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dia.nombre).font(.headline)
                                Text(dia.fechaCorta).foregroundStyle(AppTheme.accent)
                            }
                        }.accessibilityElement(children: .combine)
                        .objetivoGuiaContextual("fechas.calendario", activo: dia == ConmemoracionMuertos.allCases.first)
                    }
                    Text("Son fechas de referencia. Las costumbres y la llegada de las ánimas varían según la comunidad y la familia.")
                        .foregroundStyle(AppTheme.secondaryText)
                    Text("Los días se calculan con la fecha y la zona horaria de tu teléfono. Al terminar cada conmemoración, el contador muestra su próxima fecha anual; el día de la celebración indica Hoy.")
                        .font(.footnote).foregroundStyle(AppTheme.secondaryText)
                    Link("VisitMéxico · Calendario del Día de Muertos", destination: URL(string: "https://visitmexico.sectur.gob.mx/experiencias/dia-de-muertos")!)
                        .font(.footnote).frame(minHeight: 44, alignment: .leading)
                }.padding(24).frame(maxWidth: 640, alignment: .leading).frame(maxWidth: .infinity)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Fechas para recordar").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Listo") { dismiss() } } }
        }
        .guiaContextual(.fechas)
    }
}
