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

class ImageListViewModel: ViewBinable {
    typealias Element = ImageVO
    
    private let _imagesRelay: BehaviorRelay<[Element]> = BehaviorRelay(value: [])
    private var _requestURL: String = "http://www.gettyimagesgallery.com/collection/auto-racing/"
    
    var relay: BehaviorRelay<[ImageVO]> {
        return _imagesRelay
    }
    
    var requestURL: String {
        set {
            _requestURL = newValue
            requestData()
        }
        get {
            return _requestURL
        }
    }
    
    var disposeBag = DisposeBag()
    
    init() {
        requestData()
    }
    
    private func requestData() {
        let loader = ImageLinkLoader()
        
        loader.loadLinks(url: self.requestURL)
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
