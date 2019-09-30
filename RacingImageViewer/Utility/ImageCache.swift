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

    private var cache: [String: (Data, CGSize)] = [:]
    private let lock = NSLock()

    private init() {}

    subscript (index: String) -> (Data, CGSize)? {
            self.lock.lock()
            defer { self.lock.unlock() }
            if let indexKey = cache.index(forKey: index) {
                return cache[indexKey].value
            }

            return nil
    }

    @discardableResult
    func addData(forKey key: String, withData data: Data) -> Bool {
        guard let image = UIImage(data: data) else {
            return false
        }

        DispatchQueue.global().async {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.cache[key] = (data, image.size)
        }

        return true
    }

    static func clearCache() {
        DispatchQueue.global().async {
            shared.lock.lock()
            defer { shared.lock.unlock() }
            shared.cache.removeAll()
        }

    }
}
