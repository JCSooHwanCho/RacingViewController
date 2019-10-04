//
//  LoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class SingleDataCommand: SingleDataCommandType {
    var baseURL: URL?

    var additionalPath: String

    required init(withURL url:URL? = nil, additionalPath path: String) {
        baseURL = url
        self.additionalPath = path
    }
    
    func execute<Element:VO>() throws -> Element? {
        fatalError()
    }
}
