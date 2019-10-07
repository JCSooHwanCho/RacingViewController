//
//  DataLoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// Data를 가져오기 위한 구체 Command 객체
class DataLoadCommand: ProcessToSingleCommand {
    override func execute<Element>(withData data: Data) -> Element? {
        guard let url = self.requestURL else {
            return nil
        }
        let result = DataVO(data: data, url: url)

        return result as? Element
    }
}
