//
//  SequenceDataCommandType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation


protocol SequenceDataCommandType {

    var baseURL: String { get } // 요청을 넣는 기본 URL

    var additionalPath: String { get set } // 요청을 넣는 세부 경로

    func execute<Element>() throws -> [Element]?
 }

extension SequenceDataCommandType {
    var requestURL: URL? {
        guard let url = URL(string: baseURL + additionalPath) else {
            return nil
        }
        return url
    }
}
