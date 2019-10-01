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

class MainView: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkIndicator: UIActivityIndicatorView!

    // MARK: - Property
    var disposeBag = DisposeBag()
    var dataModel: NetworkSequenceViewModel<ImageVO>?
    private var items: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    let requestURL = "http://www.gettyimagesgallery.com/collection/auto-racing/"

    let tableViewDelegate = MainTableViewDelegate()
    let tableViewDatasource = MainTableViewDatasource()
    let tableViewPrefetchDatasource = MainTableViewPrefetcingDatasource()

    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        createDataModel()
        bindTableViewDelegate()
        bindItem()
        configureRefreshControl()

        dataModel?.loadData()
    }

    override func didReceiveMemoryWarning() {
        ImageCache.clearCache() // 메모리 부족시, 캐시를 삭제하여 메모리를 확보한다.
    }

    // MARK: - Configure Method
    private func createDataModel() {
        let command = GIGCollectionScrapingCommand(withAdditionalPath: "auto-racing")

        self.dataModel = ScrapListModel<ImageVO>(scrapingCommand: command)
    }

    private func bindItem() {
        guard let model = self.dataModel else {
            return
        }

        self.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
            self.tableView.reloadData()
            }).disposed(by: disposeBag)

        model.relay
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
        guard let model = self.dataModel else {
            return
        }

        model.relay
            .bind(to: self.tableViewDelegate.itemRelay)
            .disposed(by: disposeBag)
        model.relay
            .bind(to: self.tableViewDatasource.itemRelay)
            .disposed(by: disposeBag)
        model.relay
            .bind(to: self.tableViewPrefetchDatasource.itemRelay)
            .disposed(by: disposeBag)

        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDatasource
        self.tableView.prefetchDataSource = self.tableViewPrefetchDatasource
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
