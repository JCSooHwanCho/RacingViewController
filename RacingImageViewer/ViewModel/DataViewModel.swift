//
//  DataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class DataViewModel<Element>: RequestSingleDataViewModel<Element> {

        let lock = NSRecursiveLock()
      // MARK: - Loading Method
      override func loadData() {
        let loader = DataCachedLoader()

        guard let command = self.command,
            let url = command.requestURL else {
            return
        }

        let loadObservable = loader.loadData(withURL: url)

        loadObservable
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .compactMap { value -> Element? in
                command.execute(withData: value)
                
            }.subscribe { event in
            switch event {
            case let .next(value):
                self.lock.lock(); defer { self.lock.unlock() }
                self.itemRelay.accept(value)
                self.requestRelay.accept((true, nil))
            case let .error(error):
                self.lock.lock(); defer { self.lock.unlock() }
                self.requestRelay.accept((false, error))
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
}
