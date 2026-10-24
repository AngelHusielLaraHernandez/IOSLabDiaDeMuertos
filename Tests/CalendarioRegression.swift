//
//  CalendarioRegression.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import Foundation

@main
struct CalendarioRegression {
    static func main() {
        var total = 0
        func verificar(_ condicion: @autoclosure () -> Bool, _ mensaje: String) {
            precondition(condicion(), mensaje); total += 1
        }
        func fecha(_ iso: String) -> Date { ISO8601DateFormatter().date(from: iso)! }
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        let octubre = fecha("2026-10-23T18:00:00Z")
        verificar(ConmemoracionMuertos.mascotas.cuenta(desde: octubre, zonaHoraria: mexico).dias == 4, "27 de octubre: faltan cuatro días")
        verificar(ConmemoracionMuertos.infancia.cuenta(desde: octubre, zonaHoraria: mexico).dias == 9, "1 de noviembre: faltan nueve días")
        verificar(ConmemoracionMuertos.adultos.cuenta(desde: octubre, zonaHoraria: mexico).dias == 10, "2 de noviembre: faltan diez días")
        let diaMascotas = ConmemoracionMuertos.mascotas.cuenta(desde: fecha("2026-10-28T05:59:59Z"), zonaHoraria: mexico)
        verificar(diaMascotas.dias == 0 && diaMascotas.texto == "Hoy", "Hoy dura todo el día local, no solo la medianoche")
        let manana = ConmemoracionMuertos.infancia.cuenta(desde: fecha("2026-10-31T18:00:00Z"), zonaHoraria: mexico)
        verificar(manana.dias == 1 && manana.texto == "1 día", "El singular es legible")
        let rollover = ConmemoracionMuertos.adultos.cuenta(desde: fecha("2026-11-03T06:00:00Z"), zonaHoraria: mexico)
        verificar(rollover.dias == 364 && rollover.ano == 2027 && rollover.esSiguienteAno, "Después del día pasa al siguiente año")
        let mismoInstante = fecha("2026-11-02T05:30:00Z")
        verificar(ConmemoracionMuertos.adultos.cuenta(desde: mismoInstante, zonaHoraria: mexico).dias == 1, "El conteo respeta la fecha de México")
        verificar(ConmemoracionMuertos.adultos.cuenta(desde: mismoInstante, zonaHoraria: TimeZone(identifier: "Asia/Tokyo")!).dias == 0, "Cambiar de zona horaria cambia el día local")
        let ny = TimeZone(identifier: "America/New_York")!
        verificar(ConmemoracionMuertos.adultos.cuenta(desde: fecha("2026-10-31T16:00:00Z"), zonaHoraria: ny).dias == 2, "El cambio de horario no redondea horas a días")
        verificar(ConmemoracionMuertos.adultos.cuenta(desde: fecha("2027-11-03T18:00:00Z"), zonaHoraria: mexico).dias == 365, "El año bisiesto se incluye al pasar a 2028")
        verificar(ConmemoracionMuertos.infancia.cuenta(desde: fecha("2032-01-01T18:00:00Z"), zonaHoraria: mexico).ano == 2032, "No hay un año fijo en el calendario")
        for ano in [2026, 2027, 2028, 2032] {
            for celebracion in ConmemoracionMuertos.allCases {
                let iso = String(format: "%04d-%02d-%02dT18:00:00Z", ano, celebracion.mes, celebracion.dia)
                let cuenta = celebracion.cuenta(desde: fecha(iso), zonaHoraria: mexico)
                verificar(cuenta.dias == 0 && cuenta.ano == ano && !cuenta.esSiguienteAno, "Cada celebración reconoce su día en cualquier año")
            }
        }
        print("CALENDARIO_OK: \(total) comprobaciones")
    }
}
