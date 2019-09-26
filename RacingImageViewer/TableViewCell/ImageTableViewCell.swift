//
//  ImageTableViewCell.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    static let identifier = "ImageTableViewCell"
    
    @IBOutlet var photoView: UIImageView!
    
    func configureCell(_ tableView: UITableView, imageData image: ImageVO,cellForRowAt indexPath: IndexPath ) {
        self.selectionStyle = .none
        
        let cache = ImageCache.shared
        
        if let (data,_) = cache[image.imageURL] {
            guard let photo = UIImage(data:data) else {
                return
            }
            
            self.photoView.image = photo
        } else {
            guard let url = URL(string: image.imageURL) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) {
                (data, response,error) in
                
                guard let data = data else {
                    return
                }
                
                guard let photo = UIImage(data: data) else {
                    return
                }
                
                cache[image.imageURL] = (data,photo.size)
                DispatchQueue.main.async {
                    if(tableView.cellForRow(at: indexPath) == self) {
                        self.photoView.image = photo
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            task.resume()
        }

    }
    
    override func prepareForReuse() {
        self.photoView.image = UIImage(named: "placeholder")
    }

}
