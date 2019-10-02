//
//  ImageData.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/01.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics

// ImageData를 캐시에 저장하기 위한 Class Wrapper
class ImageData {
    let data: Data
    let size: CGSize

    init(withImageData data: Data, imageSize size: CGSize) {
        self.data = data
        self.size = size
    }
}
