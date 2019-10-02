//
//  ImageList.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

// Scrap한 데이터를 나타내는 뷰모델
final class ScrapListModel<Element:VO>: NetworkSequenceViewModel<Element> {
    typealias Element = VO

    // MARK: - Property
    var scrapingCommand: ScrapCommand? {
        didSet {
            self.loadData()
        }
    }

    var disposeBag = DisposeBag()

    // MARK: - Initializer
    init(scrapingCommand command: ScrapCommand) {
        super.init()

        scrapingCommand = command
        self.loadData()
    }

    // MARK: - Loading Method
    override func loadData() {
        let scraper = Scraper()

        guard  let command = self.scrapingCommand,
            let url = scrapingCommand?.requestURL else {
            return
        }

        let scrapObservable: Observable<[Element]> = scraper.scrapData(fromURL: url, scrapingCommand: command)
        
            scrapObservable.subscribe { event in
                switch event {
                case let .next(images):
                    self.relay.accept(images)
                    self.networkRelay.accept((true, nil))
                case let .error(error):
                    self.networkRelay.accept((false, error))
                case .completed:
                    break
                }
        }.disposed(by: disposeBag)
    }

    deinit {
         disposeBag = DisposeBag()
    }
}
