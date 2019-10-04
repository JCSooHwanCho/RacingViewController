//
//  ImageDataLoadCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

class ImageDataLoadCommand: SingleDataCommand {
    override func execute<Element>() throws -> Element? {
        do {
            guard let url = self.requestURL else {
                return nil
            }
            let data = try Data(contentsOf: url)

            let result = DataVO(data: data, url: url)

            return result as? Element
        } catch {
            throw error
        }
    }
}
