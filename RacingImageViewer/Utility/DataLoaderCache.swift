//
//  SingleDataLoaderCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// CachedLoader가 사용하는 캐시
extension DataCachedLoader {
    final class DataLoaderCache {
        static var shared = DataLoaderCache()

        private let cache: NSCache<NSURL, Observable<Data>> = NSCache()

        private init() { }

        subscript(index: URL) -> Observable<Data>? {
            let index = index as NSURL

            if let value = cache.object(forKey: index) {
                return value
            }
            return nil
        }

        func addRequest(forKey key: URL, withRequest request: Observable<Data>) {
            let key = key as NSURL
            let request = request.share(replay: 1, scope: .forever) // 구독시 가장 마자막 값을 다시 내보내는 옵저버블로 설정한다.
                .do(onError: { _ in // 에러시에는 다시 요청을 수행할 수 있도록 캐시에서 제거한다.
                self.cache.removeObject(forKey: key)
                })

            cache.setObject(request, forKey: key)
        }
    }
}
