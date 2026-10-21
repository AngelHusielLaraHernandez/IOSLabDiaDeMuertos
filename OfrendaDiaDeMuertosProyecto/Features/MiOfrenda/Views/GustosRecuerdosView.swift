//
//  GustosRecuerdosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Victor Flores on 16/10/26.
//

import SwiftUI

struct GustosRecuerdosView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let onContinuar: () -> Void
    let onVolver: () -> Void
    let onSalir: () -> Void

    private let colorFondo = AppTheme.background
    private let colorTarjeta = AppTheme.surface
    private let colorAcento = AppTheme.accent
    private let colorTextoSec = AppTheme.secondaryText

    private var puedeContinuar: Bool {
        !personalizacion.comidaFavorita.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                FlowNavigationBar(onVolver: onVolver, onSalir: onSalir)

                VStack(alignment: .leading, spacing: 6) {
                    Text("PARA UNA OFRENDA MÁS SUYA")
                        .font(.caption.weight(.bold)).tracking(0.8)
                        .foregroundColor(colorAcento)
                    Text("¿Qué le gustaba?")
                        .font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                    Text("Piensa en sus sabores, pasatiempos y momentos favoritos.")
                        .font(.subheadline).foregroundColor(colorTextoSec)
                }
                .padding(.horizontal, 24)

                // Comida favorita (Obligatorio para continuar)
                VStack(alignment: .leading, spacing: 6) {
                    Text("SU COMIDA FAVORITA")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    TextField("Por ejemplo, tamales", text: $personalizacion.comidaFavorita)
                        .font(.title3).foregroundColor(.white)
                        .textInputAutocapitalization(.sentences)
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24)

                // Música o canción favorita (Opcional)
                VStack(alignment: .leading, spacing: 6) {
                    Text("SU MÚSICA O CANCIÓN FAVORITA (OPCIONAL)")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    TextField("Por ejemplo, Cielito Lindo", text: $personalizacion.musicaFavorita)
                        .font(.title3).foregroundColor(.white)
                        .textInputAutocapitalization(.sentences)
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24)

                // Pasatiempos
                VStack(alignment: .leading, spacing: 12) {
                    Text("PASATIEMPOS Y AFICIONES")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                        .padding(.horizontal, 24)

                    ForEach(Aficion.todas) { aficion in
                        let activa = personalizacion.aficiones.contains(aficion.nombre)
                        Button {
                            if activa { personalizacion.aficiones.remove(aficion.nombre) }
                            else      { personalizacion.aficiones.insert(aficion.nombre) }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(aficion.nombre)
                                        .font(.headline).foregroundColor(.white)
                                    Text(aficion.descripcion)
                                        .font(.subheadline).foregroundColor(colorTextoSec)
                                }
                                Spacer()
                                Image(systemName: activa ? "checkmark" : "plus")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(activa ? .black : colorAcento)
                                    .padding(8)
                                    .background(activa ? colorAcento : .clear, in: .circle)
                            }
                            .padding(16)
                            .contentShape(.rect(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.tint(activa ? colorAcento.opacity(0.16) : .clear).interactive(), in: .rect(cornerRadius: 20))
                        .accessibilityAddTraits(activa ? .isSelected : [])
                        .padding(.horizontal, 24)
                    }
                }

                // Recuerdo
                VStack(alignment: .leading, spacing: 6) {
                    Text("UN RECUERDO COMPARTIDO")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                    TextField("Algo que te gustaría conservar",
                              text: $personalizacion.recuerdoCompartido)
                        .font(.title3).foregroundColor(.white)
                        .textInputAutocapitalization(.sentences)
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.75)))
                .padding(.horizontal, 24)

                Spacer(minLength: 20)

                Button {
                    onContinuar()
                } label: {
                    Text("Ver sugerencias")
                        .font(.headline).foregroundColor(.black)
                        .frame(maxWidth: .infinity).padding(.vertical, 8)

                }
                .ofrendaPrimaryAction()
                .disabled(!puedeContinuar)
                .padding(.horizontal, 24).padding(.bottom, 24)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(colorFondo.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
