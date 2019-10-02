//
//  ScrapCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// ScrapCommand의 최상위 추상 객체
class ScrapCommand: ScrapCommandType {
    var baseURL: URL?
    var additionalPath: String
    var type: ScrapType

    required init(withAdditionalPath path: String) {
        self.additionalPath = path
        type = .Unknown
    }


    func executeScraping<Element:VO>(fromURL url: URL) throws -> [Element] {
        fatalError()
    }
}

// ScrapCommand의 팩토리 메소드
extension ScrapCommand {
    static func getCommand(withCommandType type: ScrapType, additionalPath path: String) -> ScrapCommand {
        switch type {
        case .Unknown:
            return ScrapCommand(withAdditionalPath: path)
        case .GettyImageGallery:
            return GIGCollectionScrapingCommand(withAdditionalPath: path)
        }
    }
}
