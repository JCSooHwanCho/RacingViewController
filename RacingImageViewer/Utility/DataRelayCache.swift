//
//  ImageCache.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit.UIImage
import RxRelay

// Image를 Data 상태로 저장하는 Cache
final class DataRelayCache {
    static var shared = DataRelayCache()

    private let cache: NSCache<NSString,BehaviorRelay<VO>> = NSCache()

    private init() {}

    subscript (index: String) -> VO? {
        let index = index as NSString

        if let relay = cache.object(forKey: index) {
            return relay.value
        }
            return nil
    }

    func addData(forKey key: String, withData data: BehaviorRelay<VO>) {
        let key = key as NSString

        cache.setObject(data, forKey: key)
    }

    static func clearCache() {
        shared.cache.removeAllObjects()
    }
}
