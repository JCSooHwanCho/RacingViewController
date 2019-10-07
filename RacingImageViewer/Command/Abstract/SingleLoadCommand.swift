//
//  SingleDataCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// 단일 데이터를 가져오기 위한 Command 객체
class SingleDataCommand: SingleLoadCommandType {
    var baseURL: String
    var additionalPath: String

    required init(withURLString urlString: String = "", additionalPath path: String = "") {
        baseURL = urlString
        self.additionalPath = path
    }

    func execute<Element>() throws -> Element? {
        fatalError()
    }
}
