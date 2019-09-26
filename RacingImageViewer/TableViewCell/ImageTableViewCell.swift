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
    func configureCell(_ tableView: UITableView, withImageLinkData imageLink: ImageVO,cellForRowAt indexPath: IndexPath ) {
        self.selectionStyle = .none
        
        let operationCache = ImageOperationCache.shared
        let imageCache = ImageCache.shared
        
        let loadingCompleteHandler: (Data?)->() = { [weak self, weak tableView] data in
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
            
            operationCache.removeOperation(forKey: indexPath)
        }
        
        if let (imageData,_) = imageCache[imageLink.imageURL] { // 캐싱까지 완료된 상태
                guard let photo = UIImage(data: imageData) else {
                    return
                }
            
                self.photoView.image = photo
        } else  if let operation = operationCache[indexPath] {
            operation.loadingCompletionHandler = loadingCompleteHandler
        } else {
            let imageOperation = ImageLoadOperation(imageLink)
            imageOperation.loadingCompletionHandler = loadingCompleteHandler
            
            operationCache[indexPath] = imageOperation
            
            OperationQueue().addOperation(imageOperation)
        }

    }
    
    // MARK:- PrepareForReuse
    override func prepareForReuse() {
        self.photoView.image = UIImage(named: "placeholder")
    }

}
