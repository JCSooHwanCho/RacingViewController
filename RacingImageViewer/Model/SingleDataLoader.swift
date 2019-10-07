//
//  SingleDataLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// command를 이용해서 단일 데이터를 가져오는 Loader 객체
class SingleDataLoader: SingleDataLoaderType {

    // MARK: - Loading Method
    func loadData<Element>(withCommand command: SingleDataCommand) -> Observable<Element> {
        let observable = Observable<Element>.create { observable in
            do {
                guard let data: Element = try command.execute() else {
                    throw RxError.noElements
                }

                observable.onNext(data)
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }

            return Disposables.create()
        }
        return observable
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
}
