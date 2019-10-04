//
//  DataCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

final class DataCache {
    static var shared = DataCache()

    private let cache: NSCache<NSString, DataWrapper<Any>> = NSCache()

    private init() {}

    subscript (index: String) -> Any? {
        let index = index as NSString

        if let object = cache.object(forKey: index) {
            return object.value
        }
            return nil
    }

    func addData(forKey key: String, withData data: DataWrapper<Any>) {
        let key = key as NSString

        cache.setObject(data, forKey: key)
    }

    static func clearCache() {
        shared.cache.removeAllObjects()
    }
}
