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
    let viewModel = LoadDataViewModel<DataVO>()

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let operationCache = ImageOperationCache.shared
        let imageCache = DataRelayCache.shared

        for indexPath in indexPaths {
            let imageLink = self.itemRelay.value[indexPath.row]

            guard let url = URL(string: imageLink.imageURL),
                imageCache[imageLink.imageURL] == nil,
                operationCache[indexPath] == nil else { continue }

            let command = ImageDataLoadCommand(withURL: url)

            viewModel.command = command
            
            let operation = ImageLoadOperation(imageLink)

            operation.loadingCompletionHandler = { _ in
                operationCache.removeOperation(forKey: indexPath)
            }

            operationCache.addOperation(forKey: indexPath, operation: operation)
        }
    }
}
