//
//  RequestSingleDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class RequestSingleDataViewModel<Element>: RequestStatusViewModelType,
SingleDataViewModelType {
    typealias Element = Element

    var itemRelay: PublishRelay<Element> = PublishRelay()
    var requestRelay: PublishRelay<(Bool, Error?)> = PublishRelay()
    var disposeBag = DisposeBag()

    var command: SingleDataCommand? {
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
