//
//  ImageTableViewCell.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ImageTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "ImageTableViewCell"

    // MARK: - Outlet
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindViewModel()
    }

    // MARK: - Private Property
    var isLoading: Bool  = false {
        didSet {
            DispatchQueue.main.async {
                if self.isLoading {
                    self.networkIndicator.startAnimating()
                    self.networkIndicator.isHidden = false
                } else {
                    self.networkIndicator.stopAnimating()
                    self.networkIndicator.isHidden = true
                }
            }
        }
    }
    
    let viewModel = LoadDataViewModel<DataVO>()
    let dataRelay = PublishRelay<DataVO>()
    var requestURL = URL(fileURLWithPath: "")
    var requestIndex = IndexPath()

    var disposeBag = DisposeBag()

    // MARK: - Configure Method
    func configureCell(_ tableView: UITableView,
                       withImageLinkData imageLink: ImageVO,
                       cellForRowAt indexPath: IndexPath) {
        self.selectionStyle = .none // 선택시 아무런 효과가 없도록 해준다
        self.isLoading = true

        let cache = DataRelayCache.shared

        guard let url = URL(string: imageLink.imageURL) else {
            return
        }

        self.requestURL = url
        self.requestIndex = indexPath

        if let imageData = cache[url] as? DataVO {
            guard let image = UIImage(data: imageData.data) else {
                   return
               }
               self.photoView.image = image
        } else {
            let command = ImageDataLoadCommand(withURL: url)
            self.viewModel.command = command
        }
    }

    func bindViewModel() {
        self.viewModel.itemRelay
        .bind(to:self.dataRelay)
        .disposed(by: disposeBag)

        self.viewModel.networkRelay
            .subscribe(onNext: { _ in
                self.isLoading = false
            }).disposed(by: disposeBag)

        self.dataRelay
            .subscribe(onNext: { value in
                DispatchQueue.main.async {
                    guard self.requestURL == value.url,
                     let tv = self.superview as? UITableView,
                        tv.indexPath(for:self) == self.requestIndex else { return }

                    guard let image = UIImage(data: value.data) else {
                        return
                    }
                    self.photoView.image = image

                    tv.reloadRows(at: [self.requestIndex], with: .automatic)
                }
            }).disposed(by:disposeBag)
    }

    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()

        self.isLoading = false
        self.photoView.image = UIImage(named: "placeholder")
    }

    deinit {
        disposeBag = DisposeBag()
    }
}
