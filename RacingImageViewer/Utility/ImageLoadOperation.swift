//
//  ImageLoadOperation.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics

class ImageLoadOperation: Operation {
    var loadingCompletionHandler: ((Data?)-> Void)?
    var errorHandler: (() -> Void)?
    private var image: ImageVO
    
    init(_ image: ImageVO) {
        self.image = image
    }
    
    override func main() {
        if isCancelled {
            self.errorHandler?()
            return
        }

        guard let url = URL(string: image.imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
                else {
                    self.errorHandler?()
                    return
                }
            
            let imageCache = ImageCache.shared
            imageCache.addData(forKey: self.image.imageURL, withData: data)
            self.loadingCompletionHandler?(data)
        }.resume()
    }
    
}
