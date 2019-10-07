//
//  SingleImageTableViewDatasource.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/27.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import UIKit
import RxRelay

final class SingleImageTableViewDatasource: NSObject, UITableViewDataSource {
    let itemRelay: BehaviorRelay<[LinkVO]> = BehaviorRelay(value: [])
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleImageTableViewCell.identifier, for: indexPath)
        
        guard let imageCell = cell as? SingleImageTableViewCell else {
            return cell
        }
        
        let itemList = self.itemRelay.value
        let imageLink = itemList[indexPath.row]
        
        imageCell.configureCell(withImageLinkData: imageLink)
        
        return imageCell
    }
}
