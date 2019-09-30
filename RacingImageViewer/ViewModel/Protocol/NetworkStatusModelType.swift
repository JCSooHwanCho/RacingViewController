//
//  NetworkStatusModelProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/30.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

protocol NetworkStatusModelType {
    var networkRelay: PublishRelay<(Bool,Error?)> { get }
}
