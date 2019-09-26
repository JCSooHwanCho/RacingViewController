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
            cache[index] = newValue
        }
        get {
            if let imageInfo = cache[index] {
                return imageInfo
            }
            
            return nil
        }
    }
    
    @discardableResult
    func addData(forKey key: String, withData data: Data) -> Bool {
        guard let image = UIImage(data: data) else {
            return false
        }
        
        cache[key] = (data,image.size)
        
        return true
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
