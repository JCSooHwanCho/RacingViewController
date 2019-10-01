//
//  ScrapCommandProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

protocol ScrapCommandType {

    var baseURL: URL? { get }

    var additionalPath: String { set get }

    var requestURL: URL? { get }

    var type: ScrapType { get }
    
    func executeScraping<VO:StringVOType>(fromURL url: URL) throws -> [VO]
}

extension ScrapCommandType {
    var requestURL: URL? {
        return baseURL?.appendingPathComponent(additionalPath)
    }
}
