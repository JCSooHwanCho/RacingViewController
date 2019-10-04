//
//  SingleImageTableViewDatasourcePrefetching.swift
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
        let imageCache = DataCache.shared

        for indexPath in indexPaths {
            let imageURL = self.itemRelay.value[indexPath.row].imageURL

            guard imageCache[imageURL] == nil else { continue }

            let command = ImageDataLoadCommand(withURLString: imageURL)

            viewModel.command = command
        }
    }
}
