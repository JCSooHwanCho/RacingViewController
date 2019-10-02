//
//  HTMLLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class DataScraper: DataScraperType {

    // MARK: - Loading Observable
    func scrapData<Element:VO>(fromURL url: URL, scrapingCommand command: ScrapCommand) ->Observable<[Element]> {

        let dataObservable = Observable<[Element]>.create { observable in
                do {
                    let arr = try command.executeScraping(fromURL: url) as [Element]

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
