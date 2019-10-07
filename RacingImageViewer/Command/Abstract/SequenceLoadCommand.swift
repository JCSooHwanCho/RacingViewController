//
//  SequenceDataCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// 여러개의 데이터를 가져오기 위한 Command 객체
class SequenceLoadCommand: SequenceLoadCommandType {
    var baseURL: String
    var additionalPath: String

    required init(withURLString urlString: String = "", additionalPath path: String = "") {
        baseURL = urlString
        self.additionalPath = path
    }

    func execute<Element>() throws -> [Element]? {
        fatalError()
    }
}
