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

class ScrapListModel<E>: SequenceDataModel<E> {
    typealias Element = E
    
    // MARK:- Property
    private let _relay: BehaviorRelay<[E]> = BehaviorRelay(value: [])
    
    override var relay: BehaviorRelay<[E]> {
        return _relay
    }
    
    var scrapingCommand: ScrapCommand<E>? {
        didSet {
            self.loadData()
        }
    }
    var disposeBag = DisposeBag()
    
    // MARK:- Initializer
    init(scrapingCommand command: ScrapCommand<E>) {
        super.init()
        
        scrapingCommand = command
        loadData()
    }
    
    // MARK:- Loading Method
    override func loadData() {
        disposeBag = DisposeBag() // 기존 구독을 해지한다.
        
        let loader = BasicScraper<E>()
        
        guard let url = scrapingCommand?.requestURL,
            let command = self.scrapingCommand else {
            return
        }
        
        loader.scrapData(url: url,scrapingCommand: command)
            .subscribe { event in
                switch event {
                case let .next(images):
                    self.relay.accept(images)
                case let .error(error):
                    print(error)
                case .completed:
                    break
                }
        }.disposed(by: disposeBag)
    }
    
    deinit {
         disposeBag = DisposeBag()
    }
}
