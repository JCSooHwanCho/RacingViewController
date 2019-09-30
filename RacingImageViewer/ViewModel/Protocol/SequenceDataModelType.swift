//
//  ViewBindable.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

protocol SequenceDataModelType {
    associatedtype Element
    
    var relay: BehaviorRelay<[Element]> {get}
    
    func loadData()
}
