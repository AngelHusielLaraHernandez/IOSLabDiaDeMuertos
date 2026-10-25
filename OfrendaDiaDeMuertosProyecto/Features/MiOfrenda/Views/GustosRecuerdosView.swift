import SwiftUI

struct GustosRecuerdosView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let elementosStore: ElementosOfrendaStore          // NUEVO
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
                    Text("Piensa en sus sabores, pasatiempos y momentos favoritos. Cada pasatiempo pondrá sus objetos en la ofrenda.")
                        .font(.subheadline).foregroundColor(colorTextoSec)
                }
                .padding(.horizontal, 24)

                // Comida favorita
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

                Text("La comida, las aficiones y los recuerdos se comparten entre las personas de esta ofrenda. La música se configura en cada retrato.")
                    .font(.subheadline).foregroundStyle(AppTheme.secondaryText).padding(.horizontal, 24)

                // Pasatiempos
                VStack(alignment: .leading, spacing: 12) {
                    Text("PASATIEMPOS Y AFICIONES")
                        .font(.caption.weight(.bold)).tracking(0.6)
                        .foregroundColor(colorAcento)
                        .padding(.horizontal, 24)

                    ForEach(Aficion.todas) { aficion in
                        let activa = personalizacion.aficiones.contains(aficion.nombre)
                        Button { toggleAficion(aficion) } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(aficion.nombre)
                                        .font(.headline).foregroundColor(.white)
                                    Text(aficion.descripcion)
                                        .font(.subheadline).foregroundColor(colorTextoSec)
                                    if !aficion.grupos.isEmpty {
                                        Text(aficion.grupos.map(\.nombre).joined(separator: " · "))
                                            .font(.caption2)
                                            .foregroundColor(colorAcento.opacity(0.8))
                                    }
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

                // Vista previa de elementos
                vistaPreviaElementos

                Spacer(minLength: 20)

                Button { onContinuar() } label: {
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
        .task {
            await elementosStore.cargar()
            sincronizarAficionesDesdeElementos()
        }
        .onChange(of: personalizacion.aficiones) { _, _ in
            sincronizarElementosDesdeAficiones()
        }
    }

    // MARK: - Sincronización

    private func toggleAficion(_ aficion: Aficion) {
        if personalizacion.aficiones.contains(aficion.nombre) {
            personalizacion.aficiones.remove(aficion.nombre)
        } else {
            personalizacion.aficiones.insert(aficion.nombre)
        }
    }

    /// Recalcula visibilidad del modelo a partir de los pasatiempos marcados.
    private func sincronizarElementosDesdeAficiones() {
        elementosStore.establecer(.retrato, visible: true)
        let cubiertos = Set(personalizacion.aficiones.flatMap { nombre in
            Aficion.todas.first(where: { $0.nombre == nombre })?.grupos ?? []
        })
        for grupo in GrupoElementoOfrenda.allCases where grupo != .retrato {
            elementosStore.establecer(grupo, visible: cubiertos.contains(grupo))
        }
    }

    /// Al abrir la vista por primera vez, refleja qué elementos están visibles
    /// (compatibilidad con ofrendas guardadas antes del cambio).
    private func sincronizarAficionesDesdeElementos() {
        for aficion in Aficion.todas where !aficion.grupos.isEmpty {
            let todosVisibles = aficion.grupos.allSatisfy { elementosStore.configuracion.muestra($0) }
            if todosVisibles {
                personalizacion.aficiones.insert(aficion.nombre)
            } else {
                personalizacion.aficiones.remove(aficion.nombre)
            }
        }
    }

    // MARK: - Vista previa de elementos

    private var vistaPreviaElementos: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ELEMENTOS EN TU OFRENDA")
                .font(.caption.weight(.bold)).tracking(0.6)
                .foregroundColor(colorAcento)
            if elementosStore.configuracion.visibles.isEmpty {
                Text("Aún no hay objetos. Marca un pasatiempo para añadirlos.")
                    .font(.caption).foregroundColor(colorTextoSec)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(elementosStore.configuracion.visibles) { grupo in
                            Text(grupo.nombre)
                                .font(.caption)
                                .padding(.horizontal, 10).padding(.vertical, 4)
                                .background(colorTarjeta, in: .capsule)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(colorTarjeta.opacity(0.5)))
        .padding(.horizontal, 24)
    }
}
