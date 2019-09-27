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
    
    var requestURL: String? {
        didSet {
            self.bind()
        }
    }
    
    var scrapingCommand: ScrapCommand<E>?
    var disposeBag = DisposeBag()
    
    // MARK:- Initializer
    init(withURL url: String, scrapingCommand command: ScrapCommand<E>) {
        super.init()
        
        requestURL = url
        scrapingCommand = command
        bind()
    }
    
    // MARK:- Loading Method
    override func bind() {
        disposeBag = DisposeBag() // 기존 구독을 해지한다.
        
        let loader = BasicScraper<E>()
        
        guard let url = requestURL,
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
