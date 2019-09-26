//
//  ImageLoadOperation.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit.UIImage

class ImageLoadOperation: Operation {
    var imageData: Data?
    var imageSize: CGSize?
    var loadingCompletionHandler: ((Data?)->())?
    
    private var image: ImageVO
    
    init(_ image: ImageVO) {
        self.image = image
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = URL(string: image.imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
                else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.imageData = data
            self.imageSize = image.size
            self.loadingCompletionHandler?(self.imageData)
        }.resume()
    }
    
}
