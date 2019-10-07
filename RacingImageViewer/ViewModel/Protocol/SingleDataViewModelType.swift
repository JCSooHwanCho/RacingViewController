//
//  SingleDataViewModelType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

// 데이터를 로딩하고 가공해서 전파하는 모델을 나타내는 프로토콜
protocol SingleDataViewModelType {
    associatedtype Element
    
    var command: ProcessToSingleCommand? { get set }
    
    var itemRelay: PublishRelay<Element> { get }
    
    func loadData()
}
