//
//  LecturaVozRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation
import SwiftUI
import AVFAudio

private final class AudioPrueba: @unchecked Sendable {
    private let lock = NSLock()
    private var fin = false
    private var muestras = 0
    private var pico: Float = 0
    func recibir(_ buffer: AVAudioBuffer) {
        guard let pcm = buffer as? AVAudioPCMBuffer else { return }
        lock.lock(); defer { lock.unlock() }
        if pcm.frameLength == 0 { fin = true; return }
        muestras += Int(pcm.frameLength)
        if let canal = pcm.floatChannelData?[0] {
            for i in 0..<Int(pcm.frameLength) { pico = max(pico, abs(canal[i])) }
        }
    }
    var resultado: (Bool, Int, Float) {
        lock.lock(); defer { lock.unlock() }; return (fin, muestras, pico)
    }
}

@main
struct LecturaVozRegression {
    @MainActor static func main() {
        var total = 0
        func comprobar(_ condicion: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(condicion(), mensaje); total += 1
        }
        comprobar(TextoLecturaOfrenda.limpiar("  **jardín**\nEntre **flores** y alegría.  ") == "jardín\nEntre flores y alegría.", "Conserva versos y acentos sin pronunciar asteriscos")
        comprobar(TextoLecturaOfrenda.unir(["", "Historia", "  ", "Un recuerdo."]) == "Historia\n\nUn recuerdo.", "Los bloques vacíos no crean lecturas vacías y quedan pausas entre párrafos")
        let fuente = FuenteDocumental(periodo: "Actualidad", titulo: "Memoria", detalle: "Tradición familiar.", referencia: "Archivo local", url: URL(string: "https://example.com/no-pronunciar"))
        let hito = HitoHistorico(epoca: "Siglo XX", titulo: "El altar", descripcion: "Una tradición viva.", colorPunto: .orange, fuentes: [fuente])
        let cronologia = TextoLecturaOfrenda.cronologia("Su camino", hitos: [hito])
        for texto in ["Su camino", "Siglo XX", "El altar", "Una tradición viva."] {
            comprobar(cronologia.contains(texto), "La cronología incluye época, título y descripción")
        }
        let fuentes = TextoLecturaOfrenda.fuentes(nombre: "Flores", hitos: [hito])
        comprobar(fuentes.contains("Archivo local") && fuentes.contains("Tradición familiar."), "Las fuentes conservan su referencia legible")
        comprobar(!fuentes.contains("https://"), "La narración no dicta direcciones web")
        for elemento in ["Flores", "Retrato", "Velas", "Papel", "Agua y sal", "Calaveritas", "Pan", "Comida", "Caña de azúcar", "Frutas", "Incienso", "Cigarro", "Tequila"] {
            let texto = TextoLecturaOfrenda.mapa(para: elemento)
            comprobar(texto.contains("Tradición en México") && texto.contains("Referencia:"), "Cada elemento físico incluye su referencia geográfica narrable")
            comprobar(!texto.contains("https://"), "Mapa no dicta direcciones web")
        }
        comprobar(TextoLecturaOfrenda.mapa(para: "Calaveritas literarias").contains("Sin ubicación asociada"), "El tema literario no recibe un origen geográfico inventado")
        let lector = LectorVozOfrenda()
        comprobar(lector.estado == .inactivo, "No hay reproducción automática al crear la ficha")
        lector.escuchar(" ")
        comprobar(lector.estado == .inactivo, "Un contenido vacío no inicia el motor")
        lector.detener(); lector.detener()
        comprobar(lector.estado == .inactivo && lector.mensaje == nil, "Detener es seguro e idempotente")
        guard let voz = LectorVozOfrenda.vozEnEspanol() else { fatalError("No existe una voz en español en el simulador") }
        comprobar(voz.language.hasPrefix("es"), "La voz seleccionada es española")
        let audio = AudioPrueba()
        let sintetizador = AVSpeechSynthesizer()
        let frase = AVSpeechUtterance(string: "El cempasúchil guía el camino de nuestra ofrenda.")
        frase.voice = voz
        sintetizador.write(frase) { audio.recibir($0) }
        let limite = Date().addingTimeInterval(20)
        while !audio.resultado.0 && Date() < limite {
            RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        }
        let resultado = audio.resultado
        comprobar(resultado.0 && resultado.1 > 1000 && resultado.2 > 0.001, "El motor genera audio PCM con señal real, no silencio")
        print("LECTURA_OK: \(total) comprobaciones; voz \(voz.language); muestras \(resultado.1); pico \(resultado.2)")
    }
}
