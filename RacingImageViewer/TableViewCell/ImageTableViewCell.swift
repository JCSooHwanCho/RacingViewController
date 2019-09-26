//
//  ImageTableViewCell.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    // MARK:- Identifier
    static let identifier = "ImageTableViewCell"
    
    // MARK:- Outlet
    @IBOutlet var photoView: UIImageView!
    
    // MARK:- Configure Method
    func configureCell(_ tableView: UITableView, imageData image: ImageVO,cellForRowAt indexPath: IndexPath ) {
        self.selectionStyle = .none
        
        let cache = ImageOperationCache.shared
        
        let loadingCompelteHandler: (Data?)->() = { [weak self, weak tableView] data in
            guard let self = self,
            let tableView = tableView,
            let data = data,
            let photo = UIImage(data:data) else {
                return
            }
            
            DispatchQueue.main.async {
                if tableView.indexPath(for: self) == indexPath {
                       self.photoView.image = photo
                       tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }

        }
        
        if let operation = cache[indexPath] {
            
            if operation.isFinished { // 로딩이 완료된 상태
                guard let data = operation.imageData,
                    let photo = UIImage(data: data) else {
                    return
                }
            
                self.photoView.image = photo
            } else { //로딩이 아직 안끝난 상태
                operation.loadingCompletionHandler = loadingCompelteHandler
            }
        } else {
            let imageOperation = ImageLoadOperation(image)
            imageOperation.loadingCompletionHandler = loadingCompelteHandler
            
            cache[indexPath] = imageOperation
            
            OperationQueue().addOperation(imageOperation)
        }

    }
    
    // MARK:- PrepareForReuse
    override func prepareForReuse() {
        self.photoView.image = UIImage(named: "placeholder")
    }

}
