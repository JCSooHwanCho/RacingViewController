//
//  LoadDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class LoadDataViewModel<Element>: RequestSingleDataViewModel<Element> {

        let lock = NSRecursiveLock()
      // MARK: - Loading Method
      override func loadData() {
        let loader = SingleDataCachedLoader()
        let cache = DataCache.shared

        guard let command = self.command,
            let url = command.requestURL else {
            return
        }

        if let value = cache[url] as? Element {
            self.lock.lock(); defer { self.lock.unlock() }
            self.itemRelay.accept(value)
            self.requestRelay.accept((true, nil))
        } else {
            let loadObservable: Observable<Element> = loader.loadData(loadCommand: command)

            loadObservable
                .subscribe { event in
                switch event {
                case let .next(value):
                    cache.addData(forKey: url, withData: DataWrapper(value: value))
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
}
