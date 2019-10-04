//
//  Loader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class Loader: LoaderType {
    func loadData<Element:VO>(loadCommand command: SingleDataCommand) -> Observable<Element> {
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
