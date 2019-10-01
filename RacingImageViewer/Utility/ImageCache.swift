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

    private var cache: NSCache<NSString,ImageData> = NSCache()
    private let lock = NSLock()

    private init() {}

    subscript (index: String) -> ImageData? {
        let index = index as NSString

        if let value = cache.object(forKey: index) {
            return value
        }
            return nil
    }

    @discardableResult
    func addData(forKey key: String, withData data: Data) -> Bool {
        guard let image = UIImage(data: data) else {
            return false
        }
        
        let key = key as NSString
        let imageData = ImageData(withImageData: data, imageSize: image.size)
        self.cache.setObject(imageData, forKey: key)

        return true
    }

    static func clearCache() {
        shared.cache.removeAllObjects()

    }
}
