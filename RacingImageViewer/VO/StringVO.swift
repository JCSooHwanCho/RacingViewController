//
//  StringVO.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/01.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class StringVO: StringVOType {
    func getValue(forKey key: String) -> String? {
        return values[key]
    }

    func setValue(forKey key: String, value: String) {
        values[key] = value
    }

    var values: [String:String] = [:]

    required init() {}
}
