//
//  HTMLLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class Scraper: ScraperType {

    // MARK: - Loading Observable
    func scrapData<Element:VO>(scrapingCommand command: SequenceDataCommand) ->Observable<[Element]> {

        let dataObservable = Observable<[Element]>.create { observable in
                do {
                    guard let arr: [Element] = try command.execute() else {
                        throw RxError.noElements
                    }

                    observable.onNext(arr)
                    observable.onCompleted()
                } catch {
                    observable.onError(error)
                }
            return Disposables.create()
        }

        return dataObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
    }

}
