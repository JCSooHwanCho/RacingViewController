//
//  ImageDataLoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class ImageDataLoadCommand: LoadCommand {
    override func execute<Element:VO>() throws -> Element? {
        do {
            let data = try Data(contentsOf: self.requestURL)

            let result = DataVO(data: data)

            return result as? Element
        } catch {
            throw error
        }
    }
}
