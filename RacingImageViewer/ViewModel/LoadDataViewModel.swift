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

      // MARK: - Loading Method
      override func loadData() {
        let loader = CachedLoader()
        let cache = DataRelayCache.shared

        guard let command = self.command,
            let urlString = command.requestURL?.absoluteString else {
            return
        }

        if let value = cache[urlString] as? Element {
            self.itemRelay.accept(value)
        } else {
            let loadObservable: Observable<Element> = loader.loadData(loadCommand: command)

            loadObservable.subscribe { event in
                switch event {
                case let .next(value):
                    cache.addData(forKey: urlString, withData: DataWrapper(value: value))
                    self.itemRelay.accept(value)
                    self.networkRelay.accept((true, nil))
                case let .error(error):
                    self.networkRelay.accept((false, error))
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        }
    }
}
