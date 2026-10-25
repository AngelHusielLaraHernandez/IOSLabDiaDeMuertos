//
//  GuiaRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import CoreGraphics

@main
struct GuiaRegression {
    @MainActor static func main() {
        let suite = "guia-test-\(UUID())"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        var total = 0
        func comprobar(_ condicion: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(condicion(), mensaje); total += 1
        }
        let primera = GuiaOfrendaStore(defaults: defaults)
        comprobar(!primera.activa && !primera.completada, "Un primer inicio espera al altar")
        primera.actualizarDisponibilidad(false)
        comprobar(!primera.activa, "La guía no tapa una carga o error del modelo")
        primera.actualizarDisponibilidad(true)
        comprobar(primera.paso == .explorar, "Comienza en gestos cuando el altar está listo")
        primera.anterior()
        comprobar(primera.paso == .explorar, "Anterior no sale de la primera explicación")
        primera.siguiente()
        comprobar(primera.paso == .historias, "Los pasos conservan su orden")
        primera.actualizarDisponibilidad(false)
        comprobar(primera.paso == .historias && !primera.altarDisponible, "Segundo plano conserva la posición sin completar")
        primera.actualizarDisponibilidad(true)
        comprobar(primera.paso == .historias, "Regresar no reinicia el paso")
        let interrumpida = GuiaOfrendaStore(defaults: defaults)
        interrumpida.actualizarDisponibilidad(true)
        comprobar(interrumpida.paso == .explorar, "Cerrar la app sin terminar permite volver a empezar")
        for paso in PasoGuiaOfrenda.allCases {
            comprobar(interrumpida.paso == paso, "El siguiente paso siempre corresponde a la lista")
            comprobar(!paso.titulo.isEmpty && !paso.explicacion.isEmpty, "No se presenta una ayuda vacía")
            interrumpida.siguiente()
        }
        comprobar(interrumpida.completada && !interrumpida.activa, "Terminar persiste y retira la guía")
        let posterior = GuiaOfrendaStore(defaults: defaults)
        posterior.actualizarDisponibilidad(true)
        comprobar(!posterior.activa, "No reaparece en un inicio posterior")
        posterior.repetir()
        comprobar(posterior.paso == .explorar && posterior.completada, "Repetir desde créditos conserva la preferencia guardada")
        posterior.terminar(); posterior.terminar()
        comprobar(!posterior.activa && posterior.completada, "Omitir es seguro e idempotente")
        defaults.removeObject(forKey: GuiaOfrendaStore.claveCompletada)
        let omitir = GuiaOfrendaStore(defaults: defaults)
        omitir.actualizarDisponibilidad(true); omitir.terminar()
        let despuesDeOmitir = GuiaOfrendaStore(defaults: defaults)
        despuesDeOmitir.actualizarDisponibilidad(true)
        comprobar(!despuesDeOmitir.activa, "Omitir también evita repetición automática")
        for pantalla in [CGSize(width: 390, height: 844), CGSize(width: 440, height: 956), CGSize(width: 844, height: 390)] {
            for objetivo in [CGRect(x: 10, y: 10, width: 44, height: 44), CGRect(x: 40, y: 160, width: 300, height: 44), CGRect(x: 20, y: 280, width: 320, height: 210), CGRect(x: -900, y: 90, width: 44, height: 44)] {
                let resultado = GuiaDestacadoLayout.colocar(objetivo: objetivo, pantalla: pantalla)
                comprobar(resultado.recorte.width > 0 && resultado.recorte.height > 0, "El recorte siempre es dibujable")
                comprobar(resultado.recorte.minX >= 0 && resultado.recorte.maxX <= pantalla.width, "El recorte cabe horizontalmente")
                comprobar(resultado.recorte.minY >= 0 && resultado.recorte.maxY <= pantalla.height, "El recorte cabe verticalmente")
                comprobar(resultado.alturaTarjeta > 0 && resultado.alturaTarjeta <= pantalla.height - 32, "La explicación queda limitada a la pantalla")
            }
        }
        // Contextos independientes: una ficha no descarta la ayuda de las fotografías.
        let claves = GuiaContextualAmbito.allCases.map(\.clave)
        comprobar(Set(claves).count == claves.count, "Cada tipo de hoja tiene su propia persistencia")
        for ambito in GuiaContextualAmbito.allCases {
            comprobar(!ambito.pasos.isEmpty && ambito.pasos.count <= 7, "Cada ayuda contextual es breve")
            comprobar(Set(ambito.pasos.map(\.id)).count == ambito.pasos.count, "Los objetivos de una hoja no se repiten")
            let ayuda = GuiaContextualStore(ambito: ambito, defaults: defaults)
            ayuda.presentarSiNecesaria()
            comprobar(ayuda.indice == 0, "La primera visita muestra la ayuda de esa hoja")
            ayuda.anterior()
            comprobar(ayuda.indice == 0, "Anterior respeta el comienzo contextual")
            for _ in ambito.pasos { ayuda.siguiente() }
            comprobar(!ayuda.activa && defaults.bool(forKey: ambito.clave), "Terminar recuerda únicamente este contexto")
            let regreso = GuiaContextualStore(ambito: ambito, defaults: defaults)
            regreso.presentarSiNecesaria()
            comprobar(!regreso.activa, "Otra ficha del mismo tipo no repite la ayuda")
            regreso.repetir()
            comprobar(regreso.activa && defaults.bool(forKey: ambito.clave), "La ayuda manual conserva la finalización guardada")
            regreso.terminar()
        }
        GuiaContextualStore.reiniciarAyudas(defaults: defaults)
        comprobar(claves.allSatisfy { !defaults.bool(forKey: $0) }, "La repetición global prepara las ayudas de cada hoja")
        comprobar(defaults.bool(forKey: GuiaOfrendaStore.claveCompletada), "Reiniciar las hojas no altera la guía principal")
        let ficha = GuiaContextualStore(ambito: .ficha, defaults: defaults)
        ficha.presentarSiNecesaria(); ficha.terminar()
        comprobar(!defaults.bool(forKey: GuiaContextualAmbito.marcos.clave), "Omitir una ficha no oculta la ayuda de fotografías")
        print("GUIA_OK: \(total) comprobaciones")
    }
}
