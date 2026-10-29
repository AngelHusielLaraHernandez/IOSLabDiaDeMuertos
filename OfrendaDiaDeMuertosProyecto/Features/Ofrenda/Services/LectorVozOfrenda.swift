//
//  LectorVozOfrenda.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import AVFAudio
import Combine
import OSLog


@MainActor
final class LectorVozOfrenda: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    enum Estado { case inactivo, preparando, leyendo, pausado }
    @Published private(set) var estado: Estado = .inactivo
    @Published private(set) var mensaje: String?
    private var sintetizador: AVSpeechSynthesizer?
    private var lecturaActual: AVSpeechUtterance?
    private var esperaInicio: Task<Void, Never>?
    private let logger = Logger(subsystem: "Tenshi.OfrendaDiaDeMuertosProyecto", category: "LecturaVoz")

    private func prepararSintetizador() -> AVSpeechSynthesizer {
        if let sintetizador { return sintetizador }
        let nuevo = AVSpeechSynthesizer()
        nuevo.delegate = self

        nuevo.usesApplicationAudioSession = false
        sintetizador = nuevo
        return nuevo
    }

    static func vozEnEspanol() -> AVSpeechSynthesisVoice? {
        AVSpeechSynthesisVoice(language: "es-MX") ?? AVSpeechSynthesisVoice(language: "es-ES")
    }

    func escuchar(_ texto: String) {
        detener()
        let texto = TextoLecturaOfrenda.limpiar(texto)
        guard !texto.isEmpty else { return }
        guard let voz = Self.vozEnEspanol() else {
            mensaje = "No hay una voz en español disponible en este dispositivo."
            return
        }
        let lectura = AVSpeechUtterance(string: texto)
        lectura.voice = voz
        lectura.rate = 0.46
        lectura.prefersAssistiveTechnologySettings = true
        lecturaActual = lectura
        estado = .preparando
        prepararSintetizador().speak(lectura)
        let identidad = ObjectIdentifier(lectura)
        esperaInicio = Task { @MainActor [weak self] in
            do { try await Task.sleep(for: .seconds(8)) } catch { return }
            guard let self, self.esActual(identidad), self.estado == .preparando else { return }
            self.detener()
            self.mensaje = "No se pudo iniciar la voz. Comprueba las voces disponibles en el dispositivo y vuelve a intentarlo."
        }
    }

    func pausar() {
        guard estado == .leyendo, sintetizador?.pauseSpeaking(at: .immediate) == true else { return }
        estado = .pausado
    }

    func continuar() {
        guard estado == .pausado, sintetizador?.continueSpeaking() == true else { return }
        estado = .leyendo
    }

    func detener() {
        esperaInicio?.cancel()
        esperaInicio = nil
        lecturaActual = nil
        sintetizador?.stopSpeaking(at: .immediate)
        estado = .inactivo
        mensaje = nil
    }

    private func esActual(_ identidad: ObjectIdentifier) -> Bool {
        lecturaActual.map { ObjectIdentifier($0) == identidad } ?? false
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        let identidad = ObjectIdentifier(utterance)
        Task { @MainActor [weak self] in
            guard let self, self.esActual(identidad) else { return }
            self.esperaInicio?.cancel()
            self.esperaInicio = nil
            self.estado = .leyendo
            self.logger.info("Lectura iniciada")
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finalizar(ObjectIdentifier(utterance), cancelada: false)
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        finalizar(ObjectIdentifier(utterance), cancelada: true)
    }

    nonisolated private func finalizar(_ identidad: ObjectIdentifier, cancelada: Bool) {
        Task { @MainActor [weak self] in
            guard let self, self.esActual(identidad) else { return }
            self.esperaInicio?.cancel()
            self.esperaInicio = nil
            self.lecturaActual = nil
            self.estado = .inactivo
            if cancelada { self.mensaje = "La lectura se interrumpió. Puedes volver a escucharla." }
            self.logger.info("Lectura terminada; cancelada: \(cancelada)")
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        let identidad = ObjectIdentifier(utterance)
        Task { @MainActor [weak self] in
            guard let self, self.esActual(identidad) else { return }
            self.estado = .pausado
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        let identidad = ObjectIdentifier(utterance)
        Task { @MainActor [weak self] in
            guard let self, self.esActual(identidad) else { return }
            self.estado = .leyendo
        }
    }
}
