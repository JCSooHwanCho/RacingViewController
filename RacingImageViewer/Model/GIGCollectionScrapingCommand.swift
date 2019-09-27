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
    override func executeScraping(htmlText text: String) -> [ImageVO] {
        do {
            let doc = try HTML(html: text,encoding: .utf8)
                            
            let selector = try CSS.toXPath("div[class=grid-item image-item col-md-4]")
            
            var arr: [ImageVO] = []
            for node in doc.xpath(selector) {
                if let imageNode = node.at_css("img") {
                    if let imageURL = imageNode["data-src"] {
                        
                        let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://") // http요청을 위해 https를 http로 바꾼다.
                        let image = ImageVO(imageURL: httpURL)
                        arr.append(image)
                    }
                }
            }
            return arr
        } catch {
            return []
        }
    }
}
