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
    func scrapData<VO:StringVOType>(url requestURL: URL, scrapingCommand command: ScrapCommand) ->Observable<[VO]> {

        let dataObservable = Observable<[VO]>.create { observable in
                do {
                    let htmlText = try String(contentsOf: requestURL, encoding: .utf8)

                    let arr = command.executeScraping(htmlText: htmlText) as [VO]

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
