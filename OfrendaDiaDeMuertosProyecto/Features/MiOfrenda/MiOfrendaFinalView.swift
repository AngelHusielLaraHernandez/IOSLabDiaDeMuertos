//
//  MiOfrendaFinalView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct MiOfrendaFinalView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let onEditarGustos: () -> Void
    let onCambiarFoto: () -> Void
    let onVolver: () -> Void

    @State private var calaverita: String?
    @State private var mostrarCalaverita = false

    private let colorFondo = Color(red: 0.11, green: 0.05, blue: 0.18)
    private let colorTarjeta = Color(red: 0.21, green: 0.13, blue: 0.30)
    private let colorAcento = Color(red: 0.96, green: 0.65, blue: 0.25)
    private let colorTextoSec = Color.white.opacity(0.7)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                HStack {
                    Button { onVolver() } label: {
                        Label("Volver", systemImage: "chevron.left")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(colorAcento)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24).padding(.top, 12)

                VStack(alignment: .leading, spacing: 6) {
                    Text("SUS GUSTOS, SU HISTORIA")
                        .font(.caption.weight(.bold)).tracking(0.8)
                        .foregroundColor(colorAcento)
                    Text("Mi ofrenda para \(personalizacion.nombre.isEmpty ? "…" : personalizacion.nombre).")
                        .font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                }
                .padding(.horizontal, 24)

                // Card principal: 3D + resumen
                HStack(alignment: .top, spacing: 12) {
                    OfrendaModelView(
                        resetToken: 0,
                        photo: $personalizacion.foto,
                        onLoad: { _ in }
                    )
                    .frame(width: 180, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 8) {
                        Text(personalizacion.nombre.uppercased())
                            .font(.caption.weight(.bold)).tracking(0.8)
                            .foregroundColor(colorAcento)

                        Text("Sus flores\ny \(personalizacion.comidaFavorita.isEmpty ? "recuerdos" : personalizacion.comidaFavorita.lowercased()).")
                            .font(.title3.weight(.bold)).foregroundColor(.white)

                        Button("Cambiar foto") { onCambiarFoto() }
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(colorAcento)
                            .padding(.top, 4)
                    }
                    Spacer()
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24)

                // Lo que le gustaba
                HStack {
                    Text("LO QUE LE GUSTABA")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    Spacer()
                    Button("Editar gustos") { onEditarGustos() }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(colorAcento)
                }
                .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    MiniTarjeta(titulo: "COMIDA",
                                valor: personalizacion.comidaFavorita.isEmpty ? "—" : personalizacion.comidaFavorita,
                                icono: "🍲",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)

                    MiniTarjeta(titulo: "AFICIÓN",
                                valor: personalizacion.aficiones.first ?? "—",
                                icono: personalizacion.aficiones.first.map { n in
                                    Aficion.todas.first { $0.nombre == n }?.icono ?? "✨"
                                } ?? "✨",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)

                    MiniTarjeta(titulo: "RECUERDO",
                                valor: personalizacion.recuerdoCompartido.isEmpty ? "—" : personalizacion.recuerdoCompartido,
                                icono: "📸",
                                colorTarjeta: colorTarjeta, colorAcento: colorAcento)
                }
                .padding(.horizontal, 24)

                // Calaverita
                VStack(alignment: .leading, spacing: 12) {
                    Text("SUS RECUERDOS, HECHOS VERSOS")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)

                    if mostrarCalaverita, let calaverita {
                        Text(calaverita)
                            .font(.body).italic()
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .transition(.opacity)
                    } else {
                        Text("Un poema con humor inspirado en sus gustos y momentos compartidos.")
                            .font(.subheadline).foregroundColor(colorTextoSec)
                    }

                    Button {
                        withAnimation(.easeInOut) {
                            calaverita = generarCalaverita()
                            mostrarCalaverita = true
                        }
                    } label: {
                        Text(mostrarCalaverita ? "Regenerar calaverita literaria" : "Generar calaverita literaria")
                            .font(.headline).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(colorAcento, in: Capsule())
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24).padding(.bottom, 32)
            }
        }
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private func generarCalaverita() -> String {
        let nombre = personalizacion.nombre.isEmpty ? "el alma querida" : personalizacion.nombre
        let comida = personalizacion.comidaFavorita.isEmpty ? "pan de muerto" : personalizacion.comidaFavorita.lowercased()
        let aficion = personalizacion.aficiones.first?.lowercased() ?? "recordar"
        let recuerdo = personalizacion.recuerdoCompartido.isEmpty
            ? "las tardes en silencio" : personalizacion.recuerdoCompartido.lowercased()

        return """
        La Catrina llegó a casa
        con \(comida) entre las manos,
        y le dijo a \(nombre) al oído:
        «ya te esperan tus hermanos».

        Entre \(aficion) y velas,
        entre flores y cantar,
        se colaron los recuerdos
        de \(recuerdo), sin parar.

        Hoy la ofrenda se ilumina
        con tu risa y tu mirar,
        y en cada pétalo de cempasúchil
        te volvemos a abrazar.
        """
    }
}

private struct MiniTarjeta: View {
    let titulo: String
    let valor: String
    let icono: String
    let colorTarjeta: Color
    let colorAcento: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 10, weight: .bold)).tracking(0.5)
                .foregroundColor(colorAcento)
            Text(icono).font(.title2)
            Text(valor)
                .font(.subheadline.weight(.semibold)).foregroundColor(.white)
                .lineLimit(3).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.7)))
    }
}
