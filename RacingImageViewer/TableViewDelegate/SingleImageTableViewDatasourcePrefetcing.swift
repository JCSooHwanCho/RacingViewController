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
import RxSwift

final class SingleImageTableViewDatasourcePrefetching: NSObject, UITableViewDataSourcePrefetching {
    let itemRelay: BehaviorRelay<[LinkVO]> = BehaviorRelay(value: [])
    let viewModel = LoadDataViewModel<DataVO>()
    var disposeBag = DisposeBag()

    override init() {
        super.init()

        // 요청한 데이터를 캐싱한다.
        viewModel.itemRelay
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { value in
            let cache = DataCache.shared

            if cache[value.url] == nil {
                cache.addData(forKey: value.url, withData: value)
            }
        }).disposed(by:disposeBag)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let imageCache = DataCache.shared

        for indexPath in indexPaths {
            let imageLink = self.itemRelay.value[indexPath.row].link

            guard imageCache[imageLink] == nil else { continue }

            let command = DataLoadCommand(withURLString: imageLink)

            viewModel.command = command
        }
    }
}
