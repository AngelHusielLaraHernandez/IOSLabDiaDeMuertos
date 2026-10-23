//
//  TradicionesRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import MapKit

@main
struct TradicionesRegression {
    @MainActor static func main() {
        var comprobaciones = 0
        func comprobar(_ valor: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(valor(), mensaje); comprobaciones += 1
        }
        let suite = "tradiciones-pruebas-\(UUID())"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let progreso = ProgresoRecorridoStore(defaults: defaults)
        comprobar(progreso.cantidad == 0, "Un recorrido nuevo debe empezar vacío")
        comprobar(progreso.total == OfrendaCatalog.elementos.count, "El recorrido debe incluir el catálogo real completo")
        comprobar(TradicionesCatalog.celebraciones.allSatisfy { !progreso.desbloqueada($0) }, "No se desbloquean celebraciones sin explorar")
        progreso.visitar(nombre: "No existe")
        comprobar(progreso.cantidad == 0, "Un ID inválido no suma progreso")
        progreso.visitar(nombre: "Flores"); progreso.visitar(nombre: "Flores"); progreso.visitar(nombre: "Cempasúchil")
        comprobar(progreso.cantidad == 1, "Revisitar y usar alias no suma varias veces")
        for (indice, elemento) in OfrendaCatalog.elementos.enumerated() {
            progreso.visitar(nombre: elemento.nombre)
            comprobar(progreso.cantidad == indice + 1, "Cada elemento real suma una sola visita")
            for celebracion in TradicionesCatalog.celebraciones {
                comprobar(progreso.desbloqueada(celebracion) == (progreso.cantidad >= celebracion.historiasRequeridas), "Un desbloqueo debe respetar su umbral")
            }
            comprobar(TradicionesCatalog.vinculo(para: elemento.nombre) != nil, "Todo elemento debe tener un vínculo cultural")
        }
        comprobar(progreso.completo, "La insignia corresponde a los 13 elementos")
        let reabierto = ProgresoRecorridoStore(defaults: defaults)
        comprobar(reabierto.visitados == progreso.visitados, "Las visitas deben recuperarse al crear de nuevo el almacén")
        comprobar(reabierto.nombresVisitados == Set(OfrendaCatalog.elementos.map(\.nombre)), "El contador anterior debe recibir nombres compatibles")
        for alias in ["Pan de muerto", "Papel picado", "Vaso de tequila"] { reabierto.visitar(nombre: alias) }
        comprobar(reabierto.cantidad == 13, "Los alias no alteran el total máximo")
        defaults.set(["flores", "futuro-invalido", "flores"], forKey: "ofrenda.recorrido.v1")
        comprobar(ProgresoRecorridoStore(defaults: defaults).visitados == [.flores], "Una clave desconocida no rompe la reapertura")
        comprobar(Set(TradicionesCatalog.lugares.map(\.id)).count == TradicionesCatalog.lugares.count, "Los destinos deben tener identificadores únicos")
        for lugar in TradicionesCatalog.lugares {
            comprobar((14...33).contains(lugar.latitud) && (-118 ... -86).contains(lugar.longitud), "Los puntos del catálogo deben estar en la región de México")
            comprobar(!lugar.fuentes.isEmpty, "Los lugares necesitan fuentes")
            comprobar(lugar.fuentes.allSatisfy { $0.url.scheme == "https" }, "Las fuentes deben usar enlaces HTTPS")
            comprobar(!lugar.referencia.isEmpty && !lugar.avisoVisita.isEmpty, "La ruta debe explicar qué punto muestra")
        }
        comprobar(TradicionesCatalog.celebraciones.map(\.historiasRequeridas) == [3, 6, 13], "Los umbrales deben coincidir con la propuesta")
        comprobar(TradicionesCatalog.celebraciones.allSatisfy { !$0.avisoEdicion.isEmpty && !$0.verificadoEl.isEmpty }, "Cada celebración necesita contexto de edición y fecha de revisión")
        comprobar(TransporteCultural.automovil.modoMapas == MKLaunchOptionsDirectionsModeDriving, "Automóvil debe solicitar conducción")
        comprobar(TransporteCultural.transportePublico.modoMapas == MKLaunchOptionsDirectionsModeTransit, "Transporte público debe solicitar tránsito")
        comprobar(TransporteCultural.caminando.modoMapas == MKLaunchOptionsDirectionsModeWalking, "Caminando debe solicitar ruta peatonal")
        print("TRADICIONES_OK: \(comprobaciones) comprobaciones")
    }
}
