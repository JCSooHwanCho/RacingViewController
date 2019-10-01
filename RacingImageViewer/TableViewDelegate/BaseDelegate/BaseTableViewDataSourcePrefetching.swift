//
//  BaseTableViewDataSourcePrefetching.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/01.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxRelay
import UIKit

class BaseTableViewDatasourcePrefetching: NSObject, UITableViewDataSourcePrefetching {
    let itemRelay: BehaviorRelay<[StringVO]> = BehaviorRelay(value: [])
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        return
    }


}
