//
// NetworkSequenceViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

// NetworkSequence 뷰모델의 추상 클래스
class NetworkSequenceViewModel<E>: NetworkSequenceDataViewModelType {
    typealias Element = E

    var relay: BehaviorRelay<[E]> = BehaviorRelay(value: [])
    var networkRelay: PublishRelay<(Bool, Error?)> = PublishRelay()

    func loadData() {
        fatalError()
    }
}
