//
//  SingleDataViewModelType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

protocol SingleDataViewModelType {
    associatedtype Element

    var command: ProcessToSingleCommand? { get set }

    var itemRelay: PublishRelay<Element> { get }

    func loadData()
}
