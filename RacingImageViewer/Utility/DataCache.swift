//
//  ImageCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// Image를 Data 상태로 저장하는 Cache
final class DataCache {
    static var shared = DataCache()

    private let cache: NSCache<NSURL, DataWrapper<Any>> = NSCache()

    private init() {}

    subscript (index: URL) -> Any? {
        let index = index as NSURL

        if let object = cache.object(forKey: index) {
            return object.value
        }
            return nil
    }

    func addData(forKey key: URL, withData data: DataWrapper<Any>) {
        let key = key as NSURL

        cache.setObject(data, forKey: key)
    }

    static func clearCache() {
        shared.cache.removeAllObjects()
    }
}
