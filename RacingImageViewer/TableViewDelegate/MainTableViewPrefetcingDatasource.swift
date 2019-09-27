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

class MainTableViewPrefetcingDatasource: NSObject, UITableViewDataSourcePrefetching {
    
    let itemRelay: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let operationCache = ImageOperationCache.shared
        let imageCache = ImageCache.shared
        
        for indexPath in indexPaths {
            let imageLink = self.itemRelay.value[indexPath.row]
            if let _ = imageCache[imageLink.imageURL] { // 이미 다운로드된 이미지
                continue
            }
            
            if let _ = operationCache[indexPath] { // 현재 요청중인 이미지라면
                continue
            }
            let operation = ImageLoadOperation(self.itemRelay.value[indexPath.row])
            
            operation.loadingCompletionHandler = { _ in
                operationCache.removeOperation(forKey: indexPath)
            }
            
            operationCache[indexPath] = operation
            GlobalOperationQueue.global.addOperation(operation)
        }
    }
}
