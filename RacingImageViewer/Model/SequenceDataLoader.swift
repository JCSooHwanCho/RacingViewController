//
//  SequenceDataLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// command를 이용해서 Sequence형태의 데이터를 가져오는 Loader 객체
class SequenceDataLoader: SequenceDataLoaderType {
    // MARK: - Loading Method
    func loadData<Element>(withCommand command: SequenceLoadCommand) ->Observable<[Element]> {

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

        // 데이터를 불러오는 작업은 무조건 백그라운드에서 진행된다.
        return dataObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
    }

}
