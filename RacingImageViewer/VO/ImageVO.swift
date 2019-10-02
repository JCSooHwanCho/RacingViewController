//
//  ImageModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// 스크랩한 이미지를 저장하는 Value Object
final class ImageVO: StringVO {
    var imageURL: String {
        set {
            self.setValue(forKey: "imageURL", value: newValue)
        }
        get {
            return self.getValue(forKey: "imageURL") ?? ""
        }
    }
}
