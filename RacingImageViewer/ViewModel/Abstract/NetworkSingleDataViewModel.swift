//
//  NetworkSingleDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

class NetworkSingleDataViewModel<Element>: NetworkSingleDataViewModelType {
    typealias Element = Element

    var relay: BehaviorRelay<Element?> = BehaviorRelay(value: nil)
    var networkRelay: PublishRelay<(Bool, Error?)> = PublishRelay()

    func loadData() {
        fatalError()
    }
}
