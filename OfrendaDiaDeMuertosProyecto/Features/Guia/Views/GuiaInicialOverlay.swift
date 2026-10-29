//
//  GuiaInicialOverlay.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI


struct GuiaInicialOverlay: View {
    let paso: PasoGuiaOfrenda
    let objetivo: CGRect
    let pantalla: CGSize
    @ObservedObject var guia: GuiaOfrendaStore
    var body: some View {
        GuiaDestacadoView(numero: paso.numero, total: PasoGuiaOfrenda.allCases.count,
            titulo: paso.titulo, texto: paso.explicacion, identificador: String(paso.rawValue),
            objetivo: objetivo, pantalla: pantalla,
            anterior: paso == .explorar ? nil : { guia.anterior() },
            siguiente: { guia.siguiente() }, omitir: { guia.terminar() }, tituloFinal: "Empezar a explorar")
    }
}


struct GuiaDestacadoView: View {
    let numero: Int
    let total: Int
    let titulo: String
    let texto: String
    let identificador: String
    let objetivo: CGRect
    let pantalla: CGSize
    let anterior: (() -> Void)?
    let siguiente: () -> Void
    let omitir: () -> Void
    let tituloFinal: String
    @AccessibilityFocusState private var tituloEnfocado: Bool

    var body: some View {
        let lugar = GuiaDestacadoLayout.colocar(objetivo: objetivo, pantalla: pantalla)
        ZStack {
            Color.black.opacity(0.74).ignoresSafeArea()
                .mask {
                    Rectangle().overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: lugar.recorte.width, height: lugar.recorte.height)
                            .position(x: lugar.recorte.midX, y: lugar.recorte.midY)
                            .blendMode(.destinationOut)
                    }.compositingGroup()
                }
                .accessibilityHidden(true)
            // El fondo cubre también el recorte para impedir que un toque active el control explicado.
            Color.clear.contentShape(.rect).onTapGesture { }.accessibilityHidden(true)
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(AppTheme.accent, lineWidth: 2)
                .frame(width: lugar.recorte.width, height: lugar.recorte.height)
                .position(x: lugar.recorte.midX, y: lugar.recorte.midY)
                .allowsHitTesting(false).accessibilityHidden(true)
            VStack {
                if lugar.tarjetaAbajo { Spacer(minLength: 0) }
                tarjeta
                    .frame(maxWidth: 500)
                    .frame(maxHeight: lugar.alturaTarjeta)
                    .padding(16)
                if !lugar.tarjetaAbajo { Spacer(minLength: 0) }
            }
            .frame(width: pantalla.width, height: pantalla.height)
        }
        .foregroundStyle(.white)
        .accessibilityAddTraits(.isModal)
        .task(id: identificador) {
            tituloEnfocado = false
            await Task.yield()
            tituloEnfocado = true
        }
    }

    private var tarjeta: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Text("Guía · \(numero) de \(total)")
                    .font(.subheadline.weight(.medium)).foregroundStyle(AppTheme.secondaryText)
                Spacer(minLength: 4)
                Button("Omitir", action: omitir)
                    .font(.subheadline.weight(.semibold)).frame(minHeight: 44)
                    .buttonStyle(.plain).foregroundStyle(AppTheme.accent)
                    .accessibilityIdentifier("guia.omitir")
            }
            .fixedSize(horizontal: false, vertical: true)
            ViewThatFits(in: .vertical) {
                explicacion.fixedSize(horizontal: false, vertical: true)
                ScrollView { explicacion }
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollIndicators(.visible)
                    .id(identificador)
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { acciones }
                VStack(alignment: .leading, spacing: 8) { acciones }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 4)
        }
        .padding(20)
        .background(AppTheme.surface, in: .rect(cornerRadius: 20))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var explicacion: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(titulo).font(.title2.bold())
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($tituloEnfocado)
                .accessibilityIdentifier("guia.titulo")
            Text(texto).font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder private var acciones: some View {
        if let anterior {
            Button("Anterior", action: anterior).ofrendaSecondaryAction()
                .accessibilityIdentifier("guia.anterior")
        }
        Button(numero == total ? tituloFinal : "Siguiente", action: siguiente)
            .ofrendaPrimaryAction()
            .accessibilityIdentifier("guia.siguiente")
    }
}
