//
//  LoaderCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

extension CachedLoader {
    final class LoaderCache {
        static var shared = LoaderCache()

        private let cache: NSCache<NSURL, Observable<VO>> = NSCache()

        private init() { }

        subscript(index: URL) -> Observable<VO>? {
            let index = index as NSURL

            if let value = cache.object(forKey: index) {
                return value
            }
            return nil
        }

        func addRequest(forKey key: URL, withRequest request: Observable<VO>) {
            let key = key as NSURL
            let request = request.share(replay: 1, scope: .forever)

            cache.setObject(request, forKey: key)
        }

        func deleteRequest(forKey key: URL) {
            let key = key as NSURL

            cache.removeObject(forKey: key)
        }
    }
}
