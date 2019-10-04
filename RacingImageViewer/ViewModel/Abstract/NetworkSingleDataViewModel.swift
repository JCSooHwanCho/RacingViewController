//
//  NetworkSingleDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

class NetworkSingleDataViewModel<Element>: NetworkStatusViewModelType,
SingleDataViewModelType {
    typealias Element = Element

    var command: LoadCommand? {
        didSet {
            self.loadData()
        }
    }
    var itemRelay: PublishRelay<Element> = PublishRelay()
    var networkRelay: PublishRelay<(Bool, Error?)> = PublishRelay()

    func loadData() {
        fatalError()
    }
}
