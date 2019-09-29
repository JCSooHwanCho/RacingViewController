//
//  AbstractSequenceDataModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

class SequenceDataModel<E>: SequenceDataModelProtocol {
    typealias Element = E
    
    var relay: BehaviorRelay<[E]> {
        get {
            return BehaviorRelay<[E]>(value:[])
        }
    }
    
    func loadData() {
        fatalError()
    }
}
