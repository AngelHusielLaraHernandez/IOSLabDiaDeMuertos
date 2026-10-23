//
//  TarjetaDetalleElementoView.swift
//  OfrendaDiaDeMuertosProyecto
//

import SwiftUI

struct TarjetaDetalleElementoView: View {
    let elemento: ElementoOfrenda
    let renderSession: OfrendaRenderSession
    let fotosMarcos: FotosMarcosStore
    let textoBotonCerrar: String

    var body: some View {
        VStack(spacing: 0) {
            // 1. Mostrar el modelo 3D para todos los elementos EXCEPTO la calaverita literaria.
            // Como la calaverita literaria no tiene un modelo 3D en el archivo USDZ,
            // simplemente omitimos el visor para ella.
            if elemento.nombre != "Calaveritas literarias" {
                Elemento3DView(
                    elemento: elemento,
                    fotosMarcos: fotosMarcos,
                    renderSession: renderSession
                )
                .frame(height: 260)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            
            // 2. Enrutador a la vista específica según el nombre del elemento
            switch elemento.nombre {
            case "Calaveritas":
                CalaveritasView(textoBotonCerrar: textoBotonCerrar)
                
            case "Calaveritas literarias":
                CalaveritaLiterariaView(textoBotonCerrar: textoBotonCerrar)
                
            case "Agua y sal":
                AguaYSalView(textoBotonCerrar: textoBotonCerrar)
                
            case "Caña de azúcar":
                CanaDeAzucarView(textoBotonCerrar: textoBotonCerrar)
                
            case "Cigarro":
                CigarroView(textoBotonCerrar: textoBotonCerrar)
                
            default:
                // Vista genérica de respaldo para los demás elementos
                PlantillaTarjetaElementoView(
                    icono: elemento.icono,
                    subtituloCabecera: "En el altar",
                    nombreElemento: elemento.nombre,
                    tituloHistoria: elemento.tituloHistoria,
                    parrafoHistoria1: elemento.descripcionHistoria,
                    parrafoHistoria2: "",
                    preguntaReflexion: "¿Qué representa este elemento para ti?",
                    tituloSignificado: "¿Por qué está aquí?",
                    parrafoSignificado1: elemento.significado,
                    subtituloSignificado2: "",
                    parrafoSignificado2: "",
                    notaSignificado: "",
                    hitos: [],
                    textoBotonCerrar: textoBotonCerrar
                )
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}
