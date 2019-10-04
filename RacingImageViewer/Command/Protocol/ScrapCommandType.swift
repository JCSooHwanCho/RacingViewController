//
//  ScrapCommandProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// ScrapCommand의 인터페이스 프로토콜
protocol SequenceDataCommandType {

    var baseURL: URL? { get }

    var additionalPath: String { set get }

    var requestURL: URL? { get }
    
    func execute<Element:VO>() throws -> [Element]?
 }

extension SequenceDataCommandType {
    var requestURL: URL? {
        return baseURL?.appendingPathComponent(additionalPath)
    }
}

