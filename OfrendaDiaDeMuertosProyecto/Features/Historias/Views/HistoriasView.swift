//
//  HistoriasView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//


import SwiftUI

struct HistoriasView: View {
    var isActive = true
    let elementos: [ElementoOfrenda]
    @Binding var elementoSeleccionado: ElementoOfrenda?

    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Encabezado
                VStack(alignment: .leading, spacing: 8) {
                    Text("LEE A TU RITMO")
                        .font(.caption.weight(.bold))
                        .tracking(0.8)
                        .foregroundColor(colorAcento)

                    Text("Historias de la ofrenda.")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text("Elige un objeto. Puedes empezar por cualquiera.")
                        .font(.subheadline)
                        .foregroundColor(colorTextoSec)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Lista de elementos/historias
                LazyVStack(spacing: 12) {
                    ForEach(elementos) { elemento in
                        Button {
                            elementoSeleccionado = elemento
                        } label: {
                            HStack(spacing: 16) {
                                // Contenedor del icono
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.12))
                                        .frame(width: 48, height: 48)

                                    IlustracionOfrendaView(tipo: elemento.icono, tamano: 48)
                                }

                                // Título y subtítulo
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(elemento.nombre)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(subtituloPara(elemento))
                                        .font(.subheadline)
                                        .foregroundColor(colorTextoSec)
                                }

                                Spacer()

                                // Flecha derecha
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(colorTextoSec)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(colorTarjeta.opacity(0.75))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }.recortaIlustraciones()
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .ilustracionesOfrenda(activa: isActive)
    }

    /// Retorna el subtítulo temático según el elemento
    private func subtituloPara(_ elemento: ElementoOfrenda) -> String {
        switch elemento.nombre {
        case "Flores", "Cempasúchil", "Velas":
            return "guiar el camino"
        case "Agua y sal", "Agua":
            return "recibir con cariño"
        case "Pan", "Pan de muerto", "Comida", "Frutas", "Caña de azúcar", "Tequila":
            return "compartir la mesa"
        case "Retrato", "Papel", "Papel picado", "Calaveritas", "Incienso", "Cigarro":
            return "mantener la memoria"
        default:
            return "conocer su historia"
        }
    }
}
