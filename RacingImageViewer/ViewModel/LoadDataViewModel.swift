//
//  LoadDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class LoadDataViewModel<Element:VO>: NetworkSingleDataViewModel<Element> {

        let lock = NSRecursiveLock()
      // MARK: - Loading Method
      override func loadData() {
        let loader = CachedLoader()
        let cache = DataRelayCache.shared

        guard let command = self.command,
            let url = command.requestURL else {
            return
        }

        if let value = cache[url] as? Element {
            lock.lock()
            self.itemRelay.accept(value)
            self.networkRelay.accept((true,nil))
            lock.unlock()
        } else {
            let loadObservable: Observable<Element> = loader.loadData(loadCommand: command)

            loadObservable
                .subscribe { event in
                switch event {
                case let .next(value):
                    cache.addData(forKey: url, withData: DataWrapper(value: value))
                    self.lock.lock(); defer { self.lock.unlock() }
                    self.itemRelay.accept(value)
                    self.networkRelay.accept((true, nil))
                case let .error(error):
                    self.lock.lock(); defer { self.lock.unlock() }
                    self.networkRelay.accept((false, error))
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        }
    }
}
