//
//  CalaveritaGenerator.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

enum CalaveritaGenerator {

    static func generar(para personalizacion: PersonalizacionOfrenda) -> String {

        let nombre = personalizacion.nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "el alma querida"
            : personalizacion.nombre.trimmingCharacters(in: .whitespacesAndNewlines)

        let comidaOriginal = personalizacion.comidaFavorita.trimmingCharacters(in: .whitespacesAndNewlines)
        let comida = comidaOriginal.isEmpty
            ? "pan de muerto"
            : comidaOriginal.lowercased()

        let musicaOriginal = personalizacion.musicaFavorita.trimmingCharacters(in: .whitespacesAndNewlines)
        let sonido = musicaOriginal.isEmpty
            ? "un dulce cantar"
            : "sones de \(musicaOriginal.lowercased())"

        let aficionOriginal = personalizacion.aficiones.sorted().first ?? ""
        let aficion = aficionOriginal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "sus pasatiempos"
            : aficionOriginal.lowercased()

        let recuerdoOriginal = personalizacion.recuerdoCompartido.trimmingCharacters(in: .whitespacesAndNewlines)
        let recuerdo = recuerdoOriginal.isEmpty
            ? "las tardes en paz"
            : recuerdoOriginal.lowercased()

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
            Hoy te recordamos siempre
            con **\(comida)** en el altar,
            porque hasta nuestros recuerdos
            nos invitan a celebrar.
            """,

            """
            Entre flores y velitas,
            suena **\(sonido)** al pasar;
            y aunque ya no estés presente,
            te volvemos a recordar.
            """,

            """
            Conservamos con cariño
            tu pasión por **\(aficion)**,
            pues los gustos que compartimos
            viven en el corazón.
            """,

            """
            La Calaca se dio un gusto
            con **\(comida)** y buen humor,
            y prometió volver el año
            a brindar por tu recuerdo y amor.
            """,

            """
            Si escuchamos **\(sonido)**,
            tu recuerdo volverá;
            y entre risas y canciones,
            tu presencia vivirá.
            """,

            """
            Al mirar **\(aficion)**,
            te volvemos a encontrar;
            pues los gustos de quien amamos
            nunca se han de marchitar.
            """
        ]

        let e1 = estrofasInicio.randomElement() ?? estrofasInicio[0]
        let e2 = estrofasMedio.randomElement() ?? estrofasMedio[0]
        let e3 = estrofasFin.randomElement() ?? estrofasFin[0]

        return "\(e1)\n\n\(e2)\n\n\(e3)"
    }
}
