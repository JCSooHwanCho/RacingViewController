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

class ScrapListModel<VO:StringVOType>: NetworkSequenceViewModel<VO> {
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
        disposeBag = DisposeBag() // 기존 구독을 해지한다.

        let scraper = DataScraper()

        guard  let command = self.scrapingCommand,
            let url = scrapingCommand?.requestURL else {
            return
        }

        let scrapObservable = scraper.scrapData(fromURL: url, scrapingCommand: command) as Observable<[VO]>
        
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
