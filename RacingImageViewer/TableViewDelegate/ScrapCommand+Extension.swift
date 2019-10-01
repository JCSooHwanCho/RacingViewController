//
//  ScrapCommand+Extension.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/01.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

extension ScrapCommandType {
    var tableViewDelegate: BaseTableViewDelegate {
        switch self.type {
        case .Unknown:
            return BaseTableViewDelegate()
        case .GettyImageGallery:
            return GIGTableViewDelegate()
        }
    }

    var tableViewDatasource: BaseTableViewDatasource {
        switch self.type {
        case .Unknown:
            return BaseTableViewDatasource()
        case .GettyImageGallery:
            return GIGTableViewDatasource()
        }
    }

    var tableViewDatasourcePrefetching: BaseTableViewDatasourcePrefetching {
        switch self.type {
            case .Unknown:
                return BaseTableViewDatasourcePrefetching()
            case .GettyImageGallery:
                return GIGTableViewDatasourcePrefetching()
        }
    }
}
