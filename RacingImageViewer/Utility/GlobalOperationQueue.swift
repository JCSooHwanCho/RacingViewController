//
//  OperationQueue+global.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class GlobalOperationQueue {
    static let global = OperationQueue()
    
    private init(){ }
    
    static func cancelAllOperations() {
        global.cancelAllOperations()
    }
}
