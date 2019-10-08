//
//  DataVO.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// 데이터와 데이터의 출처 URL을 묶어서 저장하는 Value Object
struct DataVO {
    let data: Data
    let url: URL
}
