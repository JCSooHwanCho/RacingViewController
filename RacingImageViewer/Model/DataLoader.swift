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
class DataLoader: DataLoaderType {

    // MARK: - Loading Method
    func loadData(withURL url: URL) -> Observable<Data> {
        let observable = Observable<Data>.create { observable in
            do {

                let data = try Data(contentsOf: url)

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
