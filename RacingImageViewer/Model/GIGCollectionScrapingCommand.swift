//
//  GIGCollectionScrapingCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import Kanna

class GIGCollectionScrapingCommand: ScrapCommand<ImageVO> {
    
    required init(withURL url: URL) {
        super.init(withURL: url)
        requestURL = url
    }
    
    convenience init() {
        if let url = URL(string: "http://www.gettyimagesgallery.com/collection/") {
            self.init(withURL: url)
        } else {
            self.init(withURL: URL(fileURLWithPath: ""))
        }

    }
    
    override func executeScraping(htmlText text: String) -> [ImageVO] {
        do {
            let doc = try HTML(html: text,encoding: .utf8)

            var arr: [ImageVO] = []

            for node in doc.css("div.grid-item.image-item.col-md-4") {
                if let imageNode = node.at_css("img"),
                    let imageURL = imageNode["data-src"] {

                        let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://") // http요청을 위해 https를 http로 바꾼다.

                        let image = ImageVO(imageURL: httpURL)
                        arr.append(image)
                }
            }
            return arr
        } catch {
            return []
        }
    }
}
