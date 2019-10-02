//
//  MainTableViewPrefetcingDatasource.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import UIKit
import RxRelay

final class SingleImageTableViewDatasourcePrefetching: NSObject, UITableViewDataSourcePrefetching {
    let itemRelay: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let operationCache = ImageOperationCache.shared
        let imageCache = ImageCache.shared

        for indexPath in indexPaths {
            let imageLink = self.itemRelay.value[indexPath.row]
            
            if imageCache[imageLink.imageURL] != nil { // 이미 다운로드된 이미지라면 prefetching할 필요가 없다.
                continue
            }

            if operationCache[indexPath] != nil { // 현재 요청중인 이미지라면 요청을 다시 넣지 않는다.
                continue
            }

            let operation = ImageLoadOperation(imageLink)

            operation.loadingCompletionHandler = { _ in
                operationCache.removeOperation(forKey: indexPath)
            }

            operationCache.addOperation(forKey: indexPath, operation: operation)
        }
    }
}
