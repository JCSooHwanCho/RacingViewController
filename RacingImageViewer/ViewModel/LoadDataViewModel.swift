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

        guard let command = self.command,
            let url = command.requestURL else {
            return
        }

        let loadObservable: Observable<Element> = loader.loadData(withCommand: command)

        loadObservable
            .subscribe { event in
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
