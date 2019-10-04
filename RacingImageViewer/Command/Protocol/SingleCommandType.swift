//
//  LoadCommandType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

protocol SingleDataCommandType {

    var baseURL: URL? { get }

    var additionalPath: String { get set }

    var requestURL: URL? { get }

    func execute<Element>() throws -> Element?
}

extension SingleDataCommandType {
    var requestURL: URL? {
        if additionalPath != "" {
            return baseURL?.appendingPathComponent(additionalPath)
        } else {
            return baseURL
        }
    }
}
