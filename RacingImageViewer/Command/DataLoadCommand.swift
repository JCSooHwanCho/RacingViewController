//
//  DataLoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// Data와 출처URL을 함께 묶어주기 위한 구체 Command객체
class DataLoadCommand: ProcessToSingleCommand {
    
    // MARK: - Method
    override func execute<Element>(withData data: Data) -> Element? {
        guard let url = self.requestURL else {
            return nil
        }
        let result = DataVO(data: data, url: url)
        
        return result as? Element
    }
}
