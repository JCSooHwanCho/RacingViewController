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

    private let cache: NSCache<NSURL, DataWrapper<Any>> = NSCache()

    private init() {}

    subscript (index: URL) -> Any? {
        let index = index as NSURL

        if let object = cache.object(forKey: index) {
            return object.value
        }
            return nil
    }

    subscript (index: String) -> Any? {
        guard let url = URL(string: index) else {
            return nil
        }

        return self[url]
    }

    func addData(forKey key: URL, withData data: Any) {
        let key = key as NSURL

        cache.setObject(DataWrapper(value: data), forKey: key)
    }
}
