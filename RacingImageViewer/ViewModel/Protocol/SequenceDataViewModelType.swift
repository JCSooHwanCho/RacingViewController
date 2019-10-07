//
//  SequenceDataViewModelType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

// 데이터를 로딩하고 Sequence 형태로 가공해서 전파하는 모델을 나타내는 프로토콜
protocol SequenceDataViewModelType {
    associatedtype Element

    var command: ProcessToSequenceCommand? { get set }

    var itemsRelay: PublishRelay<[Element]> {get}

    func loadData()
}
