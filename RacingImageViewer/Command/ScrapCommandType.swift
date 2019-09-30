//
//  ScrapCommandProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

protocol ScrapCommandType {
    associatedtype Element
    
    var requestURL: URL { get set }
    
    func executeScraping(htmlText text: String) -> [Element]
}
