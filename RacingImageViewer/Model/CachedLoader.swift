//
//  SingleDataCachedLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class SingleDataCachedLoader: SingleDataLoader {
    override func loadData<Element>(loadCommand command: SingleDataCommand) -> Observable<Element> {
        let cache = SingleDataLoaderCache.shared

        guard let url = command.requestURL else {
            return Observable.error(RxError.noElements)
        }

        return Observable<Element>.deferred {
            if let request = cache[url] {
                return request.compactMap { $0 as? Element }
            } else {
                let request: Observable<Element> = super.loadData(loadCommand: command)

                cache.addRequest(forKey: url,
                                 withRequest: request.map { $0 as Any })

                return cache[url]?.compactMap { $0 as? Element } ?? Observable.error(RxError.noElements)
            }
        }
    }
}
