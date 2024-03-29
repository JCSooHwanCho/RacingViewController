//
//  DataCachedLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// 요청을 캐싱해서, 반복적인 요청에 대한 네트워크 요청을 줄이고
// 빠른 응답을 하도록 하는 DataLoader
class DataCachedLoader: DataLoader {
    override func loadData (withURL url: URL) -> Observable<Data> {
        let cache = DataLoaderCache.shared

        return Observable<Data>.deferred {
            if let data = cache[url] { // 이전에 요청이 있었던 경우, 캐시된 값을 내보낸다.
                return data
            } else {
                let request = super.loadData(withURL: url)

                cache.addRequest(forKey: url,
                                 withRequest: request)

                return cache[url] ?? Observable.error(RxError.noElements)
            }
        }
    }
}
