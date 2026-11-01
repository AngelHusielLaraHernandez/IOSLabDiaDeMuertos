//
//  CigarroView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import SwiftUI

struct CigarroView: View {
    var textoBotonCerrar = "Volver a la ofrenda"

    var body: some View {
        PlantillaTarjetaElementoView(
            icono: .cigarro, subtituloCabecera: "En el altar",
            nombreElemento: "Cigarro",
            tituloHistoria: "Un recuerdo personal",
            parrafoHistoria1: "Algunas ofrendas de adultos incluyen un cigarro por los gustos de la persona recordada. Un folleto de Mixquic de 1993 registra esta costumbre.",
            parrafoHistoria2: "Es un objeto biográfico: puede evocar una conversación o una escena cotidiana. Su presencia cambia entre familias.",
            preguntaReflexion: "¿Qué objeto cotidiano contarías para recordar a esa persona?",
            tituloSignificado: "¿Por qué está aquí?",
            parrafoSignificado1: "Recuerda una preferencia particular. No es indispensable ni tiene un significado común a todas las ofrendas.",
            subtituloSignificado2: "Un altar que cuenta una vida",
            parrafoSignificado2: "El uso de un cigarrillo moderno en el altar no equivale a todos los usos antiguos del tabaco. La referencia local no demuestra dónde comenzó esta práctica.",
            notaSignificado: "Cada familia decide qué objetos representan mejor a la persona adulta homenajeada.",
            hitos: HistoriasDocumentadas.hitos(para: "Cigarro"),
            textoBotonCerrar: textoBotonCerrar
        )
    }
}
