//
//  PanDeMuerto.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Rodrigo L on 16/10/26.
//

import SwiftUI

struct PanDeMuertoView: View {
    var textoBotonCerrar: String = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .pan,
            subtituloCabecera: "En el altar",
            nombreElemento: "Pan de muerto",
            tituloHistoria: "El aroma de la cocina",
            parrafoHistoria1: "El pan que hoy conocemos es parte de una historia de intercambios y adaptaciones. La UNAM distingue las preparaciones rituales antiguas de maíz o amaranto de la panadería de trigo que se desarrolló tras la llegada europea.",
            parrafoHistoria2: "No hay una receta única: Oaxaca conserva panes de yema y de figuras; en Mixquic se encuentran rosquillas llamadas despeinadas. El pan redondo con canillas es una variante muy difundida, pero no resume toda la tradición.",
            preguntaReflexion: "¿Prefieres el pan espolvoreado con azúcar o con ajonjolí?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Ofrendar pan expresa afecto y una invitación a compartir la mesa. Su significado depende del contexto familiar y religioso; después de la conmemoración puede formar parte de la convivencia de los vivos.",
            subtituloSignificado2: "Leer la forma sin olvidar sus variantes",
            parrafoSignificado2: "En el pan redondo, una interpretación común asocia el círculo con el ciclo vital, las canillas con huesos o lágrimas y la esfera con el cráneo. Los panes con otras formas tienen lecturas locales distintas.",
            notaSignificado: "Un antecedente ritual no demuestra que existiera la misma receta actual. Mixquic es un ejemplo regional, no el origen de todos los panes.",
            hitos: HistoriasDocumentadas.hitos(para: "Pan de muerto"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
