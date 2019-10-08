//
//  SingleImageTableViewCell.swift
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
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private let viewModel = ProcessedDataViewModel<DataVO>()
    private var requestURL: URL?
    private var disposeBag = DisposeBag()

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
    func configureCell(withImageLinkData imageLink: LinkVO) {

        let cache = DataCache.shared

        guard let url = URL(string: imageLink.link) else {
            return
        }

        self.requestURL = url // 셀이 가장 최근에 요청한 데이터가 무엇인지 저장해놓는다.

        if let imageData = cache[url] as? DataVO { // 캐싱이 되어 있으면
            guard let image = UIImage(data: imageData.data) else {
                return
            }
            self.photoView.image = image // 추가적인 로딩없이 이미지를 세팅한다.
        } else {
            self.isLoading.accept(true) // 인디케이터를 킨다
            let command = DataLoadCommand(withURLString: imageLink.link)
            self.viewModel.command = command // 뷰모델에 이미지를 요청한다.
        }
    }

    // MARK: - ViewModel Binding Method
    func bindViewModel() {

        // 인디케이터가 꺼지고 켜지는 것을 조정한다.
        self.isLoading
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                // init에서 호출될 때 nil일 수 있기 때문에 반드시 체크를 해줘야 한다.
                guard let indicator = self.networkIndicator else {
                    return
                }

                if $0 {
                    indicator.startAnimating()
                    indicator.isHidden = false
                } else {
                    indicator.stopAnimating()
                    indicator.isHidden = true
                }
            }).disposed(by: disposeBag)

        // 요청 성공 여부와 관계없이, 인디케이터를 끈다.
        self.viewModel.requestRelay
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)

        // 요청한 데이터를 받게 되면
        self.viewModel.itemRelay
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background)) // 이하의 동작은 모두 백그라운드에서 수행된다.
            .do(onNext: { // 캐싱을 시도한다.
                let cache = DataCache.shared
                if cache[$0.url] == nil {
                    cache.addData(forKey: $0.url, withData: $0)
                }
            })
            .filter { self.requestURL == $0.url } // 셀이 현재 요청한 데이터가 들어왔는지 확인한다.
            .compactMap { UIImage(data: $0.data) } // 실제 이미지로 변환한다.
            .observeOn(ConcurrentMainScheduler.instance) // UI 코드는 모두 메인 스레드에서 실행한다.
            .subscribe(onNext: { image in
                // 현재 셀이 테이블뷰에 있는지 확인한다.
                guard let tableView = self.superview as? UITableView,
                    let indexPath = tableView.indexPath(for: self) else { return }

                self.photoView.image = image

                tableView.reloadRows(at: [indexPath], with: .automatic)
            }).disposed(by: disposeBag)
    }

    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()

        self.isLoading.accept(false)
        self.photoView.image = UIImage(named: "placeholder")
    }

    deinit {
        disposeBag = DisposeBag()
    }
}
