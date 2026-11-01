//
//  FotografiasCulturalesLoader.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Angel Lara on 16/10/26.
//

import UIKit
import ImageIO


actor FotografiasCulturalesLoader {
    static let shared = FotografiasCulturalesLoader()
    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 5
        cache.totalCostLimit = 12 * 1024 * 1024
        return cache
    }()

    func imagen(archivo: String) throws -> UIImage? {
        try Task.checkCancellation()
        if let guardada = cache.object(forKey: archivo as NSString) { return guardada }
        let nombre = (archivo as NSString).deletingPathExtension
        guard let url = Bundle.main.url(forResource: nombre, withExtension: "jpg"),
              let origen = CGImageSourceCreateWithURL(url as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
              let miniatura = CGImageSourceCreateThumbnailAtIndex(origen, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: 1100,
                kCGImageSourceShouldCacheImmediately: true
              ] as CFDictionary) else { return nil }
        try Task.checkCancellation()
        let imagen = UIImage(cgImage: miniatura)
        cache.setObject(imagen, forKey: archivo as NSString, cost: miniatura.bytesPerRow * miniatura.height)
        return imagen
    }
}
