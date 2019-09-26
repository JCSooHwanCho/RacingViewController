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

class ImageListViewModel: SequenceDataViewBinable {
    typealias Element = ImageVO
    
    // MARK:- Property
    private let imagesRelay: BehaviorRelay<[Element]> = BehaviorRelay(value: [])
    var relay: BehaviorRelay<[ImageVO]> {
        return imagesRelay
    }
    
    private var requestURL: String = "http://www.gettyimagesgallery.com/collection/auto-racing/" {
        didSet {
            self.requestData()
        }
    }
 
    var disposeBag = DisposeBag()
    
    // MARK:- Initializer
    init() {
        requestData()
    }
    
    // MARK:- Loading Method
    private func requestData() {
        disposeBag = DisposeBag() // 기존 구독을 해지한다.
        
        let loader = ImageLinkScraper()
        
        loader.scrapData(url: self.requestURL)
            .toArray()
            .subscribe { event in
                switch event {
                case let .success(images):
                    self.relay.accept(images)
                case let .error(error):
                    print(error)
                }
        }.disposed(by: disposeBag)
    }
    
    deinit {
         disposeBag = DisposeBag()
    }
}
