//
// RequestSequenceViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

// NetworkSequence 뷰모델의 추상 클래스
class RequestSequenceViewModel<Element>: RequestStatusViewModelType,
SequenceDataViewModelType {
    typealias Element = Element
    
    var itemsRelay: PublishRelay<[Element]> = PublishRelay()
    var requestRelay: PublishRelay<(Bool, Error?)> = PublishRelay()
    var disposeBag = DisposeBag()
    
    var command: ProcessToSequenceCommand? {
        didSet {
            self.loadData()
        }
    }
    
    func loadData() {
        fatalError()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
