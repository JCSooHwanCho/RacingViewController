//
//  DataWrapper.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/04.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// NSCache에 구조체를 저장하기 위한 Wrapper Class
class DataWrapper<Element> {
    let value: Element

    init(value: Element) {
        self.value = value
    }
}
