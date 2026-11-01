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
        comprobar(progreso.total == OfrendaCatalog.elementosDelAltar.count, "El recorrido debe incluir los 13 grupos físicos del altar")
        comprobar(TradicionesCatalog.celebraciones.allSatisfy { !progreso.desbloqueada($0) }, "No se desbloquean celebraciones sin explorar")
        comprobar(OfrendaCatalog.elementos.count == 14, "Historias conserva el tema literario separado")
        comprobar(OfrendaCatalog.elementosDelAltar.count == 13, "El tema literario no agrega un objeto inexistente al altar")
        let literaria = OfrendaCatalog.elementos.first { $0.nombre == "Calaveritas literarias" }
        comprobar(literaria?.esElementoDelAltar == false && literaria?.icono == .calaveritaLiteraria, "La lectura literaria conserva su identidad sin visor 3D")
<<<<<<< HEAD
=======
        comprobar(OfrendaCatalog.elementos.first { $0.nombre == "Calaveritas" }?.nombreVisible == "Calaveritas de azúcar", "La figura dulce se distingue por su título sin cambiar su ID")
>>>>>>> main
        progreso.visitar(nombre: "Calaveritas literarias")
        comprobar(progreso.cantidad == 0, "La lectura adicional no adelanta los desbloqueos del altar")
        comprobar(TradicionesCatalog.vinculo(para: "Calaveritas literarias") == nil, "Toluca no se presenta como origen de las calaveritas literarias")
        progreso.visitar(nombre: "No existe")
        comprobar(progreso.cantidad == 0, "Un ID inválido no suma progreso")
        progreso.visitar(nombre: "Flores"); progreso.visitar(nombre: "Flores"); progreso.visitar(nombre: "Cempasúchil")
        comprobar(progreso.cantidad == 1, "Revisitar y usar alias no suma varias veces")
        for (indice, elemento) in OfrendaCatalog.elementosDelAltar.enumerated() {
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
        comprobar(reabierto.nombresVisitados == Set(OfrendaCatalog.elementosDelAltar.map(\.nombre)), "El contador anterior debe recibir nombres compatibles")
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
        let urlFotos = URL(fileURLWithPath: CommandLine.arguments[1])
        let datosFotos = try! Data(contentsOf: urlFotos)
        let fotos = try! JSONDecoder().decode([FotografiaCultural].self, from: datosFotos)
        comprobar(fotos.count == TradicionesCatalog.lugares.count, "Cada lugar del mapa tiene una fotografía propia")
        comprobar(Set(fotos.map(\.id)).count == fotos.count, "Las fotografías no duplican identificadores")
        for lugar in TradicionesCatalog.lugares {
            let foto = fotos.first { $0.id == lugar.id }
            comprobar(foto != nil, "El lugar tiene una fotografía de contexto")
            comprobar(foto?.fuente.scheme == "https" && foto?.credito.isEmpty == false, "La fotografía conserva crédito y publicación original")
            comprobar(foto?.pie.isEmpty == false && foto?.descripcion.isEmpty == false, "Las fotos tienen contexto y descripción accesible")
            let archivo = urlFotos.deletingLastPathComponent().appendingPathComponent(foto!.archivo)
            let datos = try? Data(contentsOf: archivo)
            comprobar(datos?.starts(with: [0xFF, 0xD8]) == true, "La fotografía enlazada existe y es JPEG")
            comprobar((datos?.count ?? Int.max) < 400_000, "Las imágenes culturales no cargan originales pesados")
        }
        comprobar(TradicionesCatalog.vinculo(para: "Agua y sal")?.lugar.id == "mixquic", "Agua y sal se vincula al lugar donde la fuente describe ambos elementos")
        // Los nombres visibles en las fichas deben resolver el mismo destino que el catálogo 3D.
        let aliasMapa = [("Flores", "Cempasúchil"), ("Papel", "Papel picado"),
                         ("Pan", "Pan de muerto"), ("Incienso", "Incienso y copal"),
                         ("Calaveritas", "Calaveritas de azúcar"), ("Tequila", "Vaso de tequila")]
        for (id, titulo) in aliasMapa {
            let base = TradicionesCatalog.vinculo(para: id)
            let visible = TradicionesCatalog.vinculo(para: titulo)
            comprobar(base != nil && visible != nil && base?.lugar.id == visible?.lugar.id,
                      "El título visible no debe dejar el mapa vacío: \(titulo)")
        }
        for elemento in OfrendaCatalog.elementosDelAltar {
            let vinculo = TradicionesCatalog.vinculo(para: elemento.nombre)!
            comprobar(!vinculo.origen.isEmpty && !vinculo.fuentesOrigen.isEmpty,
                      "Cada mapa distingue el origen documentado de la asociación regional")
            comprobar(vinculo.fuentesOrigen.allSatisfy { $0.url.scheme == "https" },
                      "La explicación geográfica tiene referencias consultables")
        }
        // Los puntos corroborados deben seguir en el entorno público que nombra la ficha.
        comprobar(TradicionesCatalog.xochimilco.latitud > 19.260 && TradicionesCatalog.xochimilco.latitud < 19.266,
                  "La referencia de San Bernardino está en el centro histórico de Xochimilco")
        comprobar(TradicionesCatalog.toluca.latitud > 19.290 && TradicionesCatalog.toluca.latitud < 19.291,
                  "Los Portales no se confunden con una calle homónima fuera del centro")
        let nombresFicha = ["Cempasúchil", "Retrato", "Velas", "Papel picado", "Agua y sal", "Pan de muerto",
                            "Comida", "Caña de azúcar", "Frutas", "Incienso y copal", "Cigarro", "Vaso de tequila"]
        for nombre in nombresFicha {
            let hitos = HistoriasDocumentadas.hitos(para: nombre)
            comprobar(!hitos.isEmpty, "Toda ficha conserva su contenido para Conocer más")
            comprobar(hitos.allSatisfy { !$0.fuentes.isEmpty && $0.fuentes.allSatisfy { $0.url?.scheme == "https" } },
                      "Las cronologías no regresan a referencias genéricas sin publicación")
        }
        for hitos in [OfrendaCatalog.historiaCalaveritas, OfrendaCatalog.historiaCalaveritasLiterarias] {
            comprobar(hitos.allSatisfy { !$0.fuentes.isEmpty && $0.fuentes.allSatisfy { $0.url != nil } },
                      "Dulce y literatura conservan historias y fuentes separadas")
        }
        print("TRADICIONES_OK: \(comprobaciones) comprobaciones")
    }
}
