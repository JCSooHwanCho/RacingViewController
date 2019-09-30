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

    private let lock = NSLock()
    private var cache: [IndexPath: ImageLoadOperation] = [:]
    private init() {}

    subscript (index: IndexPath) -> ImageLoadOperation? {
            self.lock.lock(); defer { self.lock.unlock() }
            if let operation = cache[index] {
                return operation
            }

            return nil
    }

    func removeOperation(forKey key: IndexPath) {
        DispatchQueue.global().async {
             self.lock.lock(); defer { self.lock.unlock() }
             self.cache.removeValue(forKey: key)
         }
    }

    func addOperation(forKey key: IndexPath, operation: ImageLoadOperation) {
        DispatchQueue.global().async {
                self.lock.lock(); defer { self.lock.unlock() }
                if self.cache[key] == nil {
                    self.cache[key] = operation
                }
            }
    }

    static func clearCache() {
        shared.lock.lock(); defer { shared.lock.unlock() }
        shared.cache.removeAll()

    }
}
