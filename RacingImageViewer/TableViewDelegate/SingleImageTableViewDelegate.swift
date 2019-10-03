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

final class SingleImageTableViewDelegate: NSObject, UITableViewDelegate {
    let itemRelay: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let imageLink = self.itemRelay.value[indexPath.row]

        guard let imageData = DataRelayCache.shared[imageLink.imageURL] as? DataVO else { // 아직 캐싱되지 않은 경우
            return UITableView.automaticDimension // 기본 이미지 사이즈에 맞춘다.
        }

        // Safe Area의 사이즈를 불러온다.
        // 아이폰 X 이후의 노치형 핸드폰에서는 뷰 영역과 Safe Area의 차이가 심하므로
        // Safe Area를 기준으로 삼아야 컨텐츠가 잘리지 않는다.
        guard let safeAreaSize = UIApplication.shared.windows[0].rootViewController?
            .view.safeAreaLayoutGuide.layoutFrame.size,
            let imageSize = UIImage(data: imageData.data)?.size else {
            return UITableView.automaticDimension
        }
        
        // (cell width) : (cell height) = (image Width) : (image height)
        // cell width == safe area width
        // (cell height) = (cell width) * (image height) / (image width)
        return (safeAreaSize.width * imageSize.height)/imageSize.width
    }
}
