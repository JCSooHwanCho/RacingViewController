//
//  OperationCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//


import Foundation
import CoreGraphics

class ImageOperationCache {
    static var shared = ImageOperationCache()
    
    private var cache: [IndexPath:ImageLoadOperation] = [:]
    private init() {}
    
    subscript (index: IndexPath) -> ImageLoadOperation?{
        set {
            cache[index] = newValue
        }
        get {
            if let operation = cache[index] {
                return operation
            }
            
            return nil
        }
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
