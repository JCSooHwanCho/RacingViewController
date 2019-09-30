//
//  ScrapCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class ScrapCommand<E>: ScrapCommandType {
    typealias Element = E
    
    private var _requestURL: URL = URL(fileURLWithPath: "")
    var requestURL: URL {
        set {
            _requestURL = newValue
        }
        get {
            return _requestURL
        }
    }
    
    required init(withURL url: URL) {
        _requestURL = url
    }
    
    convenience init() {
        self.init(withURL: URL(fileURLWithPath: ""))
    }
    
    func addPath(_ p: String) {
       requestURL = requestURL.appendingPathComponent(p)
    }
    
    func executeScraping(htmlText text: String) -> [E] {
        return []
    }
}
