//
//  OperationCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics

// Image를 다운로드 받는 Operation을 저장하는 캐시
final class ImageOperationCache {
    static var shared = ImageOperationCache()

    private let cache: NSCache<NSIndexPath,ImageLoadOperation> = NSCache()
    private let queue = OperationQueue()
    
    private init() {}

    subscript (index: IndexPath) -> ImageLoadOperation? {
        if let operation = cache.object(forKey: index as NSIndexPath){
            return operation
        }
        
        return nil
    }

    func removeOperation(forKey key: IndexPath) {
        let key = key as NSIndexPath
        if let operation = self.cache.object(forKey: key) {
            operation.cancel()
            self.cache.removeObject(forKey: key)
         }
    }

    func addOperation(forKey key: IndexPath, operation: ImageLoadOperation) {
        let key = key as NSIndexPath

        if self.cache.object(forKey: key) == nil {
            self.cache.setObject(operation, forKey: key)
            self.queue.addOperation(operation)
        }
    }

    func cancelAllOperations() {
        queue.cancelAllOperations()
    }

    func clearCache() {
        self.cache.removeAllObjects()

    }
}
