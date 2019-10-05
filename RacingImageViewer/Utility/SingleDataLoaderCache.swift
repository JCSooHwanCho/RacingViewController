//
//  SingleDataLoaderCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

extension SingleDataCachedLoader {
    final class SingleDataLoaderCache {
        static var shared = SingleDataLoaderCache()

        private let cache: NSCache<NSURL, Observable<Any>> = NSCache()

        private init() { }

        subscript(index: URL) -> Observable<Any>? {
            let index = index as NSURL

            if let value = cache.object(forKey: index) {
                return value
            }
            return nil
        }

        func addRequest(forKey key: URL, withRequest request: Observable<Any>) {
            let key = key as NSURL
            let request = request.share(replay: 1, scope: .forever)
                .do(onError: { _ in
                self.cache.removeObject(forKey: key)
                })

            cache.setObject(request, forKey: key)
        }

        func deleteRequest(forKey key: URL) {
            let key = key as NSURL

            cache.removeObject(forKey: key)
        }
    }
}
