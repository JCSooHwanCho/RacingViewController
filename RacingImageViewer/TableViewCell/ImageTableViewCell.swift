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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
                        self.layoutIfNeeded()
                        self.photoView.image = photo
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
