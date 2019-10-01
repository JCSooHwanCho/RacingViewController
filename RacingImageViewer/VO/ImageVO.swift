//
//  ImageModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

final class ImageVO: StringVO {
    var imageURL: String {
        set {
            values["imageURL"] = newValue
        }
        get {
            return values["imageURL"] ?? ""
        }
    }
}
