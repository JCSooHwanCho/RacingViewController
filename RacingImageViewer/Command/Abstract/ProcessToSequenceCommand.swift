//
//  ProcessToSequenceCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// 특정 URL에서 데이터를 요청하고 이를 가공하는 Command
// 가공 결과값은 Sequence다.
class ProcessToSequenceCommand: ProcessToSequenceCommandType {
    var baseURL: String
    var additionalPath: String
    
    required init(withURLString urlString: String = "", additionalPath path: String = "") {
        baseURL = urlString
        self.additionalPath = path
    }
    
    func execute<Element>(withData data: Data) -> [Element]? {
        fatalError()
    }
}
