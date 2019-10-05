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

class SingleImageTableViewCell: UITableViewCell {

    // MARK: - Identifier
    static let identifier = "SingleImageTableViewCell"

    // MARK: - Outlet
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!

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

    private let viewModel = LoadDataViewModel<DataVO>()
    private let dataRelay = PublishRelay<DataVO>()
    private var requestURL = URL(fileURLWithPath: "")
    private var requestIndex = IndexPath()

    var disposeBag = DisposeBag()

    // MARK: - Initializer
    // 코드용 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindViewModel()
    }
    // 스토리 보드용 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindViewModel()
    }

    // MARK: - Configure Method
    func configureCell(_ tableView: UITableView,
                       withImageLinkData imageLink: ImageVO,
                       cellForRowAt indexPath: IndexPath) {

        let cache = DataCache.shared

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
            self.isLoading = true
            let command = ImageDataLoadCommand(withURLString: imageLink.imageURL)
            self.viewModel.command = command
        }
    }

    func bindViewModel() {
        self.viewModel.itemRelay
        .bind(to: self.dataRelay)
        .disposed(by: disposeBag)

        self.viewModel.requestRelay
            .subscribe(onNext: { _ in
                self.isLoading = false
            }).disposed(by: disposeBag)

        self.dataRelay
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { value in
                guard self.requestURL == value.url,
                 let tableView = self.superview as? UITableView,
                    tableView.indexPath(for: self) == self.requestIndex else { return }

                guard let image = UIImage(data: value.data) else {
                    return
                }
                self.photoView.image = image

                let cache = DataCache.shared
                cache.addData(forKey: value.url, withData: value)
                tableView.reloadRows(at: [self.requestIndex], with: .automatic)
            }).disposed(by: disposeBag)
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
