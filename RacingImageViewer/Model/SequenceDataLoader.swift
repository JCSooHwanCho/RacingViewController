//
//  SequenceDataLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class SequenceDataLoader: SequenceDataLoaderType {

    // MARK: - Loading Observable
    func scrapData<Element>(scrapingCommand command: SequenceDataCommand) ->Observable<[Element]> {

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
