//
//  DataListViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// HTML을 불러오고, 원하는 데이터를 Scrap해서 전파하는
final class ScrapListViewModel<Element>: RequestSequenceViewModel<Element> {

    let lock = NSRecursiveLock()
    // MARK: - Loading Method
    override func loadData() {
        let loader = DataCachedLoader()

        guard let command = command,
            let url = command.requestURL else {
            return
        }

        loader.loadData(withURL: url)
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .compactMap{ value -> [Element]? in
                command.execute(withData: value)

            }.subscribe { event in
            switch event {
            case let .next(value):
                self.lock.lock(); defer { self.lock.unlock() }
                self.itemsRelay.accept(value)
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
