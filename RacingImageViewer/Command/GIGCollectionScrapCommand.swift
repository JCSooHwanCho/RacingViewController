//
//  GIGCollectionScrapingCommand.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import Kanna

// gettyImagesGallery를 스크랩하기 위한 구체 Command 객체.
final class GIGCollectionScrapCommand: ProcessToSequenceCommand {

    required init(withURLString urlString: String = "", additionalPath path: String = "") {
        if urlString != "" {
            print("This Command Object has a designated URL, So 'withURL' parameter will be ignored")
        }

        let path = path.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines) // 양쪽 공백을 치환한다.
            .replacingOccurrences(of: "[\\s\n]+", with: "-", options: .regularExpression) // 공백을 언더바로 치환한다.

        super.init(additionalPath: path)

        self.baseURL = "http://www.gettyimagesgallery.com/collection/"
    }

    override func execute<Element>(withData data: Data) -> [Element]? {
        do {
            let doc = try HTML(html: data, encoding: .utf8)

            var result: [LinkVO] = []

            for node in doc.css("div img[class=jq-lazy]") { // css selector로 해당하는 노드들을 찾아서 순회한다.
                if let imageURL = node["data-src"] { // 노드에서 원하는 attribute의 값을 string으로 추출한다.
                    // http요청을 위해 https를 http로 바꾼다.
                    let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://")

                    let image = LinkVO(link: httpURL)
                    result.append(image)
                }
            }
            return result as? [Element]
        } catch {
            return nil
        }
    }
}
