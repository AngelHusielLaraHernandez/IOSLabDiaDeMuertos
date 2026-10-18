//
//  Item.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara, Rodrigo Lugo, Adolfo Garcia, Victor JAziel on 12/10/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
