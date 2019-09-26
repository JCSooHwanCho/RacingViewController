//
//  ImageCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics

class ImageCache {
    static var shared = ImageCache()
    
    private var cache: [String:(Data,CGSize)] = [:]
    private init() {}
    
    subscript (index: String) -> (Data,CGSize)?{
        get {
            guard let imageData = cache[index] else{
                return nil
            }
            
            return imageData
        }
        set {
            cache[index] = newValue
        }
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
