//
//  MainTableViewDatasource.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class MainTableViewDelegate: NSObject, UITableViewDelegate {
    let itemRelay: BehaviorRelay<[StringVO]> = BehaviorRelay(value: [])
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let imageLink = self.itemRelay.value[indexPath.row] as? ImageVO else {
            return UITableView.automaticDimension
        }

        guard let (_, size) = ImageCache.shared[imageLink.imageURL] else { // 아직 캐싱되지 않은 경우
            return UITableView.automaticDimension // 기본 이미지 사이즈에 맞춘다.
        }

        guard let safeAreaSize = UIApplication.shared.windows[0].rootViewController?
            .view.safeAreaLayoutGuide.layoutFrame.size else {
            return UITableView.automaticDimension
        }
        // (cell width) : (cell height) = (image Width) : (image height)
        // cell width == safe area width
        return (safeAreaSize.width * size.height)/size.width
    }
}
