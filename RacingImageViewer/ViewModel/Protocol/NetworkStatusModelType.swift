//
//  NetworkStatusModelProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/30.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay

// 네트워크 요청에 대한 성공/실패 여부를 나타내는 Relay를 나타내는 프로토콜
protocol NetworkStatusModelType {
    var networkRelay: PublishRelay<(Bool, Error?)> { get }
}
