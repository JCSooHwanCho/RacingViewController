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

class GIGTableViewDatasourcePrefetching: BaseTableViewDatasourcePrefetching {

    override func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let operationCache = ImageOperationCache.shared
        let imageCache = ImageCache.shared

        for indexPath in indexPaths {
            guard let imageLink = self.itemRelay.value[indexPath.row] as? ImageVO else {
                return
            }
            if imageCache[imageLink.imageURL] != nil { // 이미 다운로드된 이미지
                continue
            }

            if operationCache[indexPath] != nil { // 현재 요청중인 이미지라면
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
