//
//  SequenceDataCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class SequenceDataCommand: SequenceDataCommandType {
    var baseURL: URL?
    var additionalPath: String

    required init(withURL url: URL? = nil, additionalPath path: String = "") {
        baseURL = url
        self.additionalPath = path
    }

    func execute<Element>() throws -> [Element]? {
        fatalError()
    }
}
