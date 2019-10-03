//
//  ImageLoadOperation.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics
import RxRelay

// 이미지를 요청해서 캐시에 저장하는 Operation
final class ImageLoadOperation: Operation {
    var loadingCompletionHandler: ((Data?) -> Void)?
    var errorHandler: (() -> Void)?
    var session: URLSessionDataTask?
    
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

        session = URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
                else {
                    self.errorHandler?()
                    return
                }
            let imageCache = DataRelayCache.shared
            let dataRelay = BehaviorRelay<VO>(value: DataVO(data: data))

            imageCache.addData(forKey: self.image.imageURL, withData: dataRelay)
            self.loadingCompletionHandler?(data)
        }

        session?.resume()
    }

    override func cancel() {
        super.cancel()

        session?.cancel()
    }
}
