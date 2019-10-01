//
//  GIGCollectionScrapingCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import Kanna

final class GIGCollectionScrapingCommand: ScrapCommand {

    let lock = NSLock()

    required init(withAdditionalPath path: String) {
        super.init(withAdditionalPath: path)
        baseURL = URL(string: "http://www.gettyimagesgallery.com/collection/")
        type = .GettyImageGallery
    }

    override func executeScraping<VO:StringVOType>(fromURL url: URL) throws -> [VO] {
        do {
            let doc = try HTML(url: url, encoding: .utf8)

            var arr: [ImageVO] = []

            for node in doc.css("div img[class=jq-lazy]") {
                if let imageURL = node["data-src"] {
                    // http요청을 위해 https를 http로 바꾼다.
                    let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://")
                    let image = ImageVO()
                    image.imageURL = httpURL
                    arr.append(image)
                }
            }
            return arr as? [VO] ?? []
        } catch {
            throw error
        }
    }
}
