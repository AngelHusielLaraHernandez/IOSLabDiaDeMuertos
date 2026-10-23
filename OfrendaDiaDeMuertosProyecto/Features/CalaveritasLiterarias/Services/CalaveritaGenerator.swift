//
//  CalaveritaGenerator.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

enum CalaveritaGenerator {

    static func generar(para personalizacion: PersonalizacionOfrenda, evitando anterior: String? = nil) -> String {

        let nombreOriginal = personalizacion.nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let nombre = escaparMarkdown(nombreOriginal.isEmpty ? "el alma querida" : nombreOriginal)

        let comidaOriginal = personalizacion.comidaFavorita.trimmingCharacters(in: .whitespacesAndNewlines)
        let comida = comidaOriginal.isEmpty
            ? "pan de muerto"
            : escaparMarkdown(comidaOriginal.lowercased())

        let musicaOriginal = personalizacion.musicaFavorita.trimmingCharacters(in: .whitespacesAndNewlines)
        let sonido = musicaOriginal.isEmpty
            ? "un dulce cantar"
            : "sones de \(escaparMarkdown(musicaOriginal.lowercased()))"

        let aficionOriginal = personalizacion.aficiones.sorted().first ?? ""
        let aficion = aficionOriginal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "sus pasatiempos"
            : escaparMarkdown(aficionOriginal.lowercased())

        let recuerdoOriginal = personalizacion.recuerdoCompartido.trimmingCharacters(in: .whitespacesAndNewlines)
        let recuerdo = recuerdoOriginal.isEmpty
            ? "las tardes en paz"
            : escaparMarkdown(recuerdoOriginal.lowercased())

        // Cada estrofa incluye al menos un gusto personalizado.
        // Los datos se resaltan con Markdown.

        let estrofasInicio: [String] = [
            """
            La Huesuda llegó al barrio
            con antojo de **\(comida)**,
            preguntando por **\(nombre)**
            para alegrarse la vida.
            """,

            """
            La Catrina llegó a casa
            tarareando **\(sonido)**,
            pues sabía que **\(nombre)**
            disfrutaba aquel sonido.
            """,

            """
            Caminaba la Calaca
            buscando a **\(nombre)**,
            quien disfrutaba **\(aficion)**
            hasta que el sueño lo esconde.
            """,

            """
            La Muerte tocó la puerta
            con **\(comida)** en un platón:
            «Si me invitas a probarlo,
            te perdono la ocasión».
            """,

            """
            La Flaca llegó cantando
            al compás de **\(sonido)**,
            y encontró a **\(nombre)**
            disfrutando aquel sonido.
            """,

            """
            La Parca buscó a **\(nombre)**
            para llevarlo al panteón,
            pero al verlo con **\(aficion)**
            se olvidó de su misión.
            """
        ]

        let estrofasMedio: [String] = [
            """
            «No me lleves todavía»,
            le pidió **\(nombre)** con emoción,
            «déjame comer **\(comida)**
            y después vemos, panteón».
            """,

            """
            Entre velas y cempasúchil,
            la Flaca oyó **\(sonido)**;
            se olvidó de sus pendientes
            y bailó muy divertido.
            """,

            """
            Con **\(aficion)** se entretenía
            **\(nombre)** al atardecer,
            y la Muerte, tan curiosa,
            también lo quiso aprender.
            """,

            """
            La Calaca probó **\(comida)**
            y pidió otra ración:
            «¡Con un manjar como este,
            no regreso al panteón!».
            """,

            """
            Al escuchar **\(sonido)**,
            la Huesuda zapateó;
            tanto le gustó la música
            que hasta el alma se olvidó.
            """,

            """
            **\(nombre)** cuidaba **\(aficion)**
            con paciencia y emoción,
            y la Flaca, al contemplarlo,
            le ofreció una prórroga al panteón.
            """,

            """
            La Catrina, muy hambrienta,
            se acercó a **\(nombre)** sin temor;
            al probar **\(comida)**,
            ¡se le olvidó hasta el terror!
            """,

            """
            La Muerte pidió una pieza
            de **\(sonido)** para bailar,
            y dejó para otro día
            a quien debía sepultar.
            """
        ]

        let estrofasFin: [String] = [
            """
            Hoy recordamos a **\(nombre)**
            con **\(comida)** en el altar,
            y al pensar en **\(recuerdo)**,
            nos volvemos a encontrar.
            """,

            """
            Entre flores y velitas,
            suena **\(sonido)** al pasar;
            al recordar **\(recuerdo)**,
            te volvemos a abrazar.
            """,

            """
            Conservamos con cariño
            tu pasión por **\(aficion)**,
            y el recuerdo de **\(recuerdo)**
            vive en nuestro corazón.
            """,

            """
            La Calaca se dio un gusto
            con **\(comida)** y buen humor,
            recordando **\(recuerdo)**
            entre risas y mucho amor.
            """,

            """
            Si escuchamos **\(sonido)**,
            tu recuerdo volverá;
            al pensar en **\(recuerdo)**,
            tu presencia vivirá.
            """,

            """
            Al mirar **\(aficion)**,
            te volvemos a encontrar;
            recordando **\(recuerdo)**,
            nunca te hemos de olvidar.
            """
        ]

        var e1 = estrofasInicio.randomElement() ?? estrofasInicio[0]
        let e2 = estrofasMedio.randomElement() ?? estrofasMedio[0]
        let e3 = estrofasFin.randomElement() ?? estrofasFin[0]

        // «Generar otra» siempre cambia al menos una estrofa de la versión visible.
        if "\(e1)\n\n\(e2)\n\n\(e3)" == anterior {
            e1 = estrofasInicio.first(where: { $0 != e1 }) ?? e1
        }
        return "\(e1)\n\n\(e2)\n\n\(e3)"
    }

    /// Los gustos son texto del usuario; solo las plantillas aportan formato y enlaces.
    private static func escaparMarkdown(_ texto: String) -> String {
        let especiales: Set<Character> = ["\\", "*", "_", "`", "[", "]", "(", ")", "<", ">", "!", "~", ":", "/", ".", "@"]
        return texto.map { especiales.contains($0) ? "\\\($0)" : String($0) }.joined()
    }

}
