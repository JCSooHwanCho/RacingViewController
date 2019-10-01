//
//  StringVOType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/01.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

protocol StringVOType {
    func getValue(forKey key: String) -> String?
    mutating func setValue(forKey key: String, value: String)

    init()
}
