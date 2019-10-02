//
//  ViewController.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/25.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class SingleImageTableView: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!

    // MARK: - Private Property
    private var disposeBag = DisposeBag()
    private var dataModel: NetworkSequenceViewModel<ImageVO>?
    private var items: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])

    // MARK: - Public Property
    // PresentingViewController에서 설정한뒤 Present하는 것을 것을 상정한 Property
    var scrapType: ScrapType? = .GettyImageGallery
    var additionalPath: String? = "auto-racing"

    // MARK: - Delegate
    var tableViewDelegate = SingleImageTableViewDelegate()
    var tableViewDatasource = SingleImageTableViewDatasource()
    var tableViewDataSourcePrefetching = SingleImageTableViewDatasourcePrefetching()

    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        createDataModel() // ViewModel과 delegate들을 설정한다.
        bindItem() //ViewModel을 View와 바인딩해준다.
        bindTableViewDelegate() // 위에서 만든 delegate들을 ViewModel과 바인딩해주고, tableView에 세팅한다.
        configureRefreshControl() // tableView의 refreshControl을 설정한다.

        self.navigationItem.title = additionalPath // 네비게이션 타이틀 설정. 네비바가 없으면 뷰에는 나타나지 않는다.
    }

    // MARK: - Configure Method
    private func createDataModel() {

        guard let scrapType = self.scrapType,
            let additionalPath = self.additionalPath else {
                return
        }
        let command = ScrapCommand.getCommand(withCommandType: scrapType, additionalPath: additionalPath)

        self.dataModel = ScrapListModel<ImageVO>(scrapingCommand: command)
    }

    private func bindItem() {
        guard let model = self.dataModel else {
            return
        }

        // 데이터가 새로 들어올 때 마다 테이블 뷰를 리로드한다.
        self.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
            self.tableView.reloadData()
            }).disposed(by: disposeBag)

        let modelRelay = model.relay

        modelRelay
            .bind(to: self.items)
            .disposed(by: disposeBag)

        model.networkRelay
            .subscribe { event in

            switch event {
            case let .next((isSuccess, _)):
                if isSuccess {
                    DispatchQueue.main.async {
                        self.networkIndicator.stopAnimating()
                        self.networkIndicator.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController.getAlert(withTitle: "네트워크 오류",
                                                               message: "인터넷 연결 상태를 다시 확인해주세요") { _ in
                            model.loadData()
                        }
                       self.present(alert, animated: true)
                    }
                }
            default:
                break
            }
        }.disposed(by: disposeBag)
    }

    private func bindTableViewDelegate() {
        self.items
            .bind(to: self.tableViewDelegate.itemRelay)
            .disposed(by: disposeBag)

        self.items
            .bind(to: self.tableViewDatasource.itemRelay)
            .disposed(by: disposeBag)
        self.items
            .bind(to: self.tableViewDataSourcePrefetching.itemRelay)
            .disposed(by: disposeBag)

        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDatasource
        self.tableView.prefetchDataSource = self.tableViewDataSourcePrefetching
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshBySwipeDown), for: .valueChanged)

    }

    // MARK: - Action Method
    @objc private func refreshBySwipeDown() {
        defer {
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        dataModel?.loadData()
    }

    // MARK: - Deinit
    deinit {
        disposeBag = DisposeBag()
    }
}