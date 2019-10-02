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
    func scrapData<Element:VO>(scrapingCommand command: ScrapCommand) ->Observable<[Element]> {

        let dataObservable = Observable<[Element]>.create { observable in
                do {
                    let arr = try command.executeScraping() as [Element]

                    observable.onNext(arr)
                    observable.onCompleted()
                } catch {
                    observable.onError(error)
                }
            return Disposables.create()
        }

        return dataObservable.subscribeOn(SerialDispatchQueueScheduler.init(qos: .background))
    }

}
