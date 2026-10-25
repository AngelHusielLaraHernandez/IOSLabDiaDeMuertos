//
//  PersonalizarRetratoView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct PersonalizarRetratoView: View {
    @Binding var personalizacion: PersonalizacionOfrenda
    let fotosMarcos: FotosMarcosStore
    let onElegirFoto: () -> Void
    let onContinuar: () -> Void
    var nombresOriginales: [MarcoOfrenda: String] = [:]
    private var configuracion: Binding<ConfiguracionMarcos> {
        Binding(get: { personalizacion.configuracionInicial(desde: fotosMarcos.configuracion) }, set: { personalizacion.aplicarRetratos($0) })
    }
    private var permiteFoto: Bool {
        IdentidadRetrato.permiteReemplazar(nombreAnterior: nombresOriginales[personalizacion.marcoRetrato] ?? "",
            nombreNuevo: configuracion.wrappedValue.persona(en: personalizacion.marcoRetrato).nombre,
            esPredeterminada: fotosMarcos.esPredeterminadaGuardada(personalizacion.marcoRetrato))
    }
    private var necesitaSegundoMarco: Bool {
        configuracion.wrappedValue.cantidad == .dos && personalizacion.marcoRetrato == .izquierdo
    }
    private var puedeContinuar: Bool {
        necesitaSegundoMarco
            ? configuracion.wrappedValue.errorIdentidad(en: .izquierdo) == nil
            : configuracion.wrappedValue.errorIdentidad == nil
    }
    var body: some View {
        ScrollViewReader { desplazamiento in
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("¿A quién quieres recordar?").font(.largeTitle.bold()).padding(.horizontal, 24)
                ConfiguracionMarcosView(store: fotosMarcos, marcoElegido: $personalizacion.marcoRetrato, borrador: configuracion)
                    .padding(.horizontal, 24)
                DatosRetratosView(configuracion: configuracion, marcoSeleccionado: personalizacion.marcoRetrato, mostrarErrorGlobal: !necesitaSegundoMarco)
                    .id("datosRetrato")
                    .objetivoGuiaContextual("personalizar.nombre").padding(.horizontal, 24)
                Button(action: onElegirFoto) {
                    Label("Elegir foto del \(personalizacion.marcoRetrato.numero.lowercased())", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .ofrendaSecondaryAction().disabled(!permiteFoto).padding(.horizontal, 24)
                if !permiteFoto {
                    Text(configuracion.wrappedValue.persona(en: personalizacion.marcoRetrato).primerNombre.isEmpty
                         ? "Escribe primero su nombre para elegir una fotografía."
                         : "Para reemplazar esta fotografía, cambia también el nombre de la persona de ese marco.")
                        .font(.footnote).foregroundStyle(AppTheme.accent).padding(.horizontal, 24)
                }
                Button(necesitaSegundoMarco ? "Siguiente" : "Añadir gustos y recuerdos") {
                    if necesitaSegundoMarco {
                        personalizacion.marcoRetrato = .derecho
                        desplazamiento.scrollTo("datosRetrato", anchor: .top)
                    } else { onContinuar() }
                }
                    .frame(maxWidth: .infinity, minHeight: 44).ofrendaPrimaryAction()
                    .disabled(!puedeContinuar)
                    .accessibilityIdentifier("personalizar.continuar")
                    .accessibilityHint(necesitaSegundoMarco ? "Continúa con el nombre, la música y la foto del marco 2." : "Continúa con los gustos y recuerdos compartidos.")
                    .objetivoGuiaContextual("personalizar.continuar").padding(.horizontal, 24).padding(.bottom, 24)
            }
        }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { AyudaGuiaContextualButton() }
        }
        .guiaContextual(.crearOfrenda)
        .scrollDismissesKeyboard(.interactively)
        .background(AppTheme.background.ignoresSafeArea())
    }
}
