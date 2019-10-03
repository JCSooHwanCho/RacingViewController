//
//  ImageTableViewCell.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "ImageTableViewCell"

    // MARK: - Outlet
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!

    // MARK: - Private Property
    var isLoading: Bool  = false {
        didSet {
            if isLoading {
                networkIndicator.startAnimating()
                networkIndicator.isHidden = false
            } else {
                self.networkIndicator.stopAnimating()
                self.networkIndicator.isHidden = true
            }
        }
    }

    // MARK: - Configure Method
    func configureCell(_ tableView: UITableView,
                       withImageLinkData imageLink: ImageVO,
                       cellForRowAt indexPath: IndexPath) {
        self.selectionStyle = .none // 선택시 아무런 효과가 없도록 해준다

        let operationCache = ImageOperationCache.shared
        let imageCache = DataRelayCache.shared

        // 이미지 로딩이 완료되면 호출되는 Handler
        let loadingCompleteHandler: (Data?) -> Void = { data in
            guard let data = data, let photo = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                if tableView.indexPath(for: self) == indexPath {
                    self.isLoading = false
                    self.photoView.image = photo
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            operationCache.removeOperation(forKey: indexPath)
        }

        // 이미지 로딩에 실패하거나 이미지 로딩이 중단 되었을 때 호출되는 Handler
        let errorHandler: () -> Void = {
            DispatchQueue.main.async {
                if tableView.indexPath(for: self) == indexPath {
                    self.isLoading = false
                }
            }
        }

        if let imageData = imageCache[imageLink.imageURL] { // 캐싱이 완료된 상태
            guard let imageData = imageData as? DataVO,
                let photo = UIImage(data: imageData.data) else {
                    return
                }
                self.photoView.image = photo
        } else if let operation = operationCache[indexPath] { // 요청은 들어갔지만, 아직 다운로드가 완료되지 않은 상태
            self.isLoading = true

            operation.loadingCompletionHandler = loadingCompleteHandler
            operation.errorHandler = errorHandler
        } else { // 요청조자 들어가지 않은 상태
            let imageOperation = ImageLoadOperation(imageLink)
            imageOperation.loadingCompletionHandler = loadingCompleteHandler
            imageOperation.errorHandler = errorHandler

            self.isLoading = true

            operationCache.addOperation(forKey: indexPath, operation: imageOperation)
        }
    }

    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        self.isLoading = false
        self.photoView.image = UIImage(named: "placeholder")
    }

}
