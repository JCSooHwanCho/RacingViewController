//
//  HTMLLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class BasicScraper<E>: DataScraperProtocol  {
    typealias Element = E
    
    // MARK:- Loading Observable
    func scrapData(url requestURL: URL, scrapingCommand command: ScrapCommand<E>) ->Observable<[E]> {

        let dataObservable = Observable<[E]>.create { observable in
                do {
                    let htmlText = try String(contentsOf: requestURL, encoding: .utf8)
                    
                    let arr = command.executeScraping(htmlText: htmlText)
                    
                    observable.onNext(arr)
                    observable.onCompleted()
                } catch {
                    observable.onError(RxError.unknown)
                }
            return Disposables.create()
        }

        return dataObservable.subscribeOn(SerialDispatchQueueScheduler.init(qos: .background))
    }
    
}
