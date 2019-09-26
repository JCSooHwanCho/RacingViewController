//
//  HTMLLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import Kanna
import RxSwift

class ImageLinkLoader {
    typealias Element = ImageVO
    
    func loadLinks(url baseURL: String) ->Observable<Element> {
        guard let url = URL(string: baseURL) else {
            return Observable.error(NSError())
        }
        
        let observable = Observable<Element>.create { observable in
            DispatchQueue.main.async {
                do {
                    let htmlText = try String(contentsOf: url, encoding: .utf8)
                    let doc = try HTML(html: htmlText,encoding: .utf8)
                    
                    let selector = try CSS.toXPath("div[class=grid-item image-item col-md-4]")
                    
                    for node in doc.xpath(selector) {
                        if let imageNode = node.at_css("img") {
                            if let imageURL = imageNode["data-src"] {
                                
                                let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://") // http요청을 위해 https를 http로 바꾼다.
                                let image = Element(imageURL: httpURL)
                                observable.onNext(image)
    
                            }
                        }
                    }
                    
                    observable.onCompleted()
                } catch {
                    observable.onError(NSError())
                }
            }
            
            return Disposables.create()
        }

        return observable
    }
}
