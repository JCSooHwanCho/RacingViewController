//
//  ScrapCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class ScrapCommand: ScrapCommandType {

    var baseURL: URL?
    var additionalPath: String

    required init(withAdditionalPath path: String) {
        self.additionalPath = path
    }


    func executeScraping<VO:StringVOType>(htmlText text: String) -> [VO] {
        return []
    }
}
