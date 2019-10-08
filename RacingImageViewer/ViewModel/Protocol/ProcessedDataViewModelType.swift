//
//  ProcessedDataViewModelType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

// 데이터를 로딩하고 가공해서 전파하는 모델을 나타내는 프로토콜
protocol ProcessedDataViewModelType {
    associatedtype Element

    // 데이터가 위치한 URL과 가공 방법을 담은 Command
    var command: ProcessingCommand? { get }

    // 가공된 데이터를 전파하는 Relay
    var itemRelay: PublishRelay<Element> { get }

    // command의 성공 여부를 전파하는 Relay
    var requestRelay: PublishRelay<(Bool, Error?)> { get }

    // 데이터를 로드하고 가공해서 성공 여부와 데이터를 전파하는 메소드
    func loadData()
}
