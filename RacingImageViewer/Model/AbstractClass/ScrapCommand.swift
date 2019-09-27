//
//  ScrapCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class ScrapCommand<E>: ScrapCommandProtocol {
    typealias Element = E
    
    func executeScraping(htmlText text: String) -> [E] {
        return []
    }
}
