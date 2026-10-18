//
//  ModelLoadState.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

enum ModelLoadState: Equatable {
    case loading
    case ready
    case failed(String)
}
