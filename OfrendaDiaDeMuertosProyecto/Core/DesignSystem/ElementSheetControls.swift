//
//  ElementSheetControls.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI
import UIKit

struct ElementSheetHeader: View {
    let icono: IlustracionOfrenda
    let subtitulo: String
    let titulo: String
    var onGuardar: (() -> Void)? = nil
    var guardarDeshabilitado = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 12) {
                cabecera
                HStack { AyudaGuiaContextualButton(); Spacer(); accionCerrarOGuardar }
            }
        } else {
            HStack(spacing: 12) {
                cabecera
                AyudaGuiaContextualButton()
                accionCerrarOGuardar
            }
        }
    }

    @ViewBuilder private var accionCerrarOGuardar: some View {
        if onGuardar != nil { accionGuardar.objetivoGuiaContextual("marcos.guardar") }
        else { EmptyView() }
    }

    private var cabecera: some View {
        HStack(spacing: 12) {
            IlustracionOfrendaView(tipo: icono, tamano: 44)
            VStack(alignment: .leading, spacing: 3) {
                Text(titulo)
                    .font(.title3.bold())
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer(minLength: 4)
        }
    }

    private var accionGuardar: some View {
        Button("Guardar") { onGuardar?() }
            .fixedSize(horizontal: true, vertical: false)
            .frame(minHeight: 44)
            .ofrendaPrimaryAction()
            .disabled(guardarDeshabilitado)
            .accessibilityHint("Guarda las fotografías y la disposición de los marcos y vuelve a la ofrenda.")
            .accessibilityIdentifier("marcos.guardar")
    }
}

struct SheetSectionPicker: View {
    let secciones: [String]
    @Binding var seleccion: Int
    var titulo = "Sección del elemento"
    var distribucionUniforme = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @Environment(\.pasoGuiaContextual) private var pasoGuia
    @State private var seccionAntesGuia: Int?
    @State private var anchoDisponible: CGFloat = .greatestFiniteMagnitude

    @ScaledMetric(relativeTo: .subheadline) private var tamanoTexto: CGFloat = 15
    private var fuente: UIFont { UIFont.systemFont(ofSize: tamanoTexto, weight: .medium) }
    private var anchoMinimo: CGFloat {
        let anchos = secciones.map { texto in
            max(ceil((texto as NSString).size(withAttributes: [.font: fuente]).width),
                ceil((texto as NSString).size(withAttributes: [.font: fuente.withTraits(.traitBold)]).width)) + 28
        }
        return 8 + (distribucionUniforme ? (anchos.max() ?? 0) * CGFloat(anchos.count) : anchos.reduce(0, +))
    }
    private var altura: CGFloat {
        anchoMinimo > anchoDisponible ? max(52, ceil(fuente.lineHeight) + 24) : max(44, ceil(fuente.lineHeight) + 16)
    }

    var body: some View {
        GeometryReader { geometria in
            if anchoMinimo <= geometria.size.width {
                SelectorSeccionesNativo(secciones: secciones, seleccion: $seleccion, fuente: fuente, titulo: titulo, distribucionUniforme: distribucionUniforme)
                    .frame(width: geometria.size.width, height: max(44, ceil(fuente.lineHeight) + 16))
                    .frame(height: altura)
            } else {
                
                ScrollViewReader { desplazamiento in
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(secciones.indices, id: \.self) { indice in
                                opcionDesplazable(indice).id(indice)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: seleccion, initial: true) { _, indice in
                        desplazamiento.scrollTo(indice, anchor: .center)
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel(titulo)
            }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { anchoDisponible = $0 }
        .frame(height: altura)
        .onChange(of: pasoGuia, initial: true) { _, paso in
            if let paso, paso.hasPrefix("ficha.seccion.") {
                let titulo = String(paso.dropFirst("ficha.seccion.".count))
                if let indice = secciones.firstIndex(of: titulo) {
                    if seccionAntesGuia == nil { seccionAntesGuia = seleccion }
                    seleccion = indice
                }
            } else if paso == nil, let anterior = seccionAntesGuia {
                seleccion = anterior
                seccionAntesGuia = nil
            }
        }
    }

    @ViewBuilder private func opcionDesplazable(_ indice: Int) -> some View {
        let boton = Button { seleccion = indice } label: {
            Text(secciones[indice])
                .font(.subheadline.weight(seleccion == indice ? .bold : .medium))
                .fixedSize()
                .padding(.horizontal, 12)
                .frame(minHeight: max(44, ceil(fuente.lineHeight) + 8))
        }
        .buttonBorderShape(.capsule)
        .accessibilityAddTraits(seleccion == indice ? .isSelected : [])
        if seleccion == indice {
            boton.buttonStyle(.glassProminent).tint(AppTheme.accent).foregroundStyle(.black)
        } else {
            boton.buttonStyle(.glass).foregroundStyle(.white)
        }
    }
}


private struct SelectorSeccionesNativo: UIViewRepresentable {
    let secciones: [String]
    @Binding var seleccion: Int
    let fuente: UIFont
    let titulo: String
    let distribucionUniforme: Bool

    func makeCoordinator() -> Coordinator { Coordinator(seleccion: $seleccion) }
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: secciones)
        control.apportionsSegmentWidthsByContent = !distribucionUniforme
        control.addTarget(context.coordinator, action: #selector(Coordinator.cambiar(_:)), for: .valueChanged)
        return control
    }
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        
        CGSize(width: proposal.width ?? uiView.intrinsicContentSize.width,
               height: proposal.height ?? max(44, ceil(fuente.lineHeight) + 16))
    }
    func updateUIView(_ control: UISegmentedControl, context: Context) {
        context.coordinator.seleccion = $seleccion
        control.apportionsSegmentWidthsByContent = !distribucionUniforme
        if control.numberOfSegments != secciones.count || secciones.indices.contains(where: { control.titleForSegment(at: $0) != secciones[$0] }) {
            control.removeAllSegments()
            for (indice, texto) in secciones.enumerated() { control.insertSegment(withTitle: texto, at: indice, animated: false) }
        }
        control.setTitleTextAttributes([.font: fuente], for: .normal)
        control.setTitleTextAttributes([.font: fuente.withTraits(.traitBold)], for: .selected)
        if control.selectedSegmentIndex != seleccion { control.selectedSegmentIndex = seleccion }
        control.accessibilityLabel = titulo
    }
    @MainActor final class Coordinator: NSObject {
        var seleccion: Binding<Int>
        init(seleccion: Binding<Int>) { self.seleccion = seleccion }
        @objc func cambiar(_ control: UISegmentedControl) {
            guard control.selectedSegmentIndex != UISegmentedControl.noSegment else { return }
            seleccion.wrappedValue = control.selectedSegmentIndex
        }
    }
}

private extension UIFont {
    func withTraits(_ rasgos: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(rasgos) else { return self }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}


struct SheetReadingContent<Content: View>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ViewBuilder var content: () -> Content
    var body: some View {
        if dynamicTypeSize.isAccessibilitySize { content() }
        else { ScrollView { content() } }
    }
}
