//
//  SequenceDataCachedLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/07.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// 요청을 캐싱해서, 반복적인 요청에 대한 네트워크 요청을 줄이고
// 빠른 응답을 하도록 하는 SequenceDataLoader
class SequenceDataCachedLoader: SequenceDataLoader {
    override func loadData<Element>(withCommand command: SequenceLoadCommand) ->Observable<[Element]>  {
        let cache = SequenceDataLoaderCache.shared

        guard let url = command.requestURL else {
            return Observable.error(RxError.noElements)
        }

        return Observable<[Element]>.deferred {
            if let request = cache[url]?.compactMap({ $0 as? [Element] }) {
                return request
            } else {
                let request: Observable<[Element]> = super.loadData(withCommand: command)

                cache.addRequest(forKey: url,
                                 withRequest: request.map { $0 as [Any] })

                return cache[url]?.compactMap { $0 as? [Element] } ?? Observable.error(RxError.noElements)
            }
        }
    }
}
