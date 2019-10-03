//
//  CachedLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class CachedLoader: Loader {
    override func loadData<Element:VO>(loadCommand command: LoadCommand) -> Observable<Element>{
        let cache = LoaderCache.shared

        let url = command.requestURL

        return Observable<Element>.deferred {
            if let request = cache[url] {
                return request.compactMap { $0 as? Element }
            } else {
                let request:Observable<Element> = super.loadData(loadCommand: command)

                cache.addRequest(forKey: command.requestURL,
                withRequest: request.map{ $0 as VO })

                return request
            }
        }.do(afterError: { _ in cache.deleteRequest(forKey: url) }
            ,afterCompleted: { cache.deleteRequest(forKey: url) } )
    }
}
