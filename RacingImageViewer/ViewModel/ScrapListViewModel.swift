//
//  ImageList.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// Scrap한 데이터를 나타내는 뷰모델
final class ScrapListViewModel<Element:VO>: NetworkSequenceViewModel<Element> {

    let lock = NSRecursiveLock()
    // MARK: - Loading Method
    override func loadData() {
        let scraper = Scraper()

        guard let command = command else {
            return
        }
        
        let scrapObservable: Observable<[Element]> = scraper.scrapData( scrapingCommand: command)
        
            scrapObservable.subscribe { event in
                switch event {
                case let .next(value):
                    self.lock.lock(); defer { self.lock.unlock() }
                    self.itemsRelay.accept(value)
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
