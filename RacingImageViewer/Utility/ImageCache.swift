//
//  ImageCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit.UIImage

class ImageCache {
    static var shared = ImageCache()
    
    private var cache: [String:(Data,CGSize)] = [:]
    private init() {}
    
    subscript (index: String) -> (Data,CGSize)?{
        set {
            DispatchQueue.global().sync { // 캐시 일관성을 위해, 쓰기 작업은 동기적으로 수행한다.
                cache[index] = newValue
            }
        }
        get {
            
            if let indexKey = cache.index(forKey: index) {
                return cache[indexKey].value
            }
            
            return nil
        }
    }
    
    @discardableResult
    func addData(forKey key: String, withData data: Data) -> Bool {
        guard let image = UIImage(data: data) else {
            return false
        }
        
        DispatchQueue.global().sync { // 마찬가지로 동기적으로 수행한다.
            cache[key] = (data,image.size)
        }
        
        return true
    }
    
    static func clearCache() {
         shared.cache.removeAll()
    }
}
