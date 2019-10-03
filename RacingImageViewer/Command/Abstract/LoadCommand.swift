//
//  LoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class LoadCommand: LoadCommandType {
    var requestURL: URL

    init(withURL url: URL) {
        requestURL = url
    }
    
    func execute<Element:VO>() throws -> Element? {
        fatalError()
    }
}
