//
//  HTMLLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class BasicScraper<E>: DataScraper  {
    typealias Element = E
    
    // MARK:- Loading Observable
    func scrapData(url baseURL: String, scrapingHandler closure: @escaping (String) throws ->([E])) ->Observable<[E]> {
        guard let url = URL(string: baseURL) else {
            return Observable.error(RxError.noElements)
        }
        
        let dataObservable = Observable<[E]>.create { observable in
                do {
                    let htmlText = try String(contentsOf: url, encoding: .utf8)
                    
                    let arr = try closure(htmlText)
                    
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
