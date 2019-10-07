//
//  SingleImageTableView.swift
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
    private var viewModel: RequestSequenceViewModel<LinkVO>?
    private var items: BehaviorRelay<[LinkVO]> = BehaviorRelay(value: [])
    private var isLoading: BehaviorRelay<Bool>  = BehaviorRelay(value: true)
    
    // MARK: - Public Property
    // PresentingViewController에서 설정한뒤 Present하는 것을 것을 상정한 Property
    var additionalPath: String = "auto-racing"

    // MARK: - Delegate
    var tableViewDelegate = SingleImageTableViewDelegate()
    var tableViewDatasource = SingleImageTableViewDatasource()
    var tableViewDataSourcePrefetching = SingleImageTableViewDatasourcePrefetching()

    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        defer { commandToViewModel() } // 뷰모델에 command를 전달한다.
        super.viewDidLoad()

        createDataModel() // ViewModel을 만든다.
        bindItem() //ViewModel을 View와 바인딩해준다.
        bindTableViewDelegate() // 위에서 만든 delegate들을 ViewModel과 바인딩해주고, tableView에 세팅한다.
        configureRefreshControl() // tableView의 refreshControl을 설정한다.

        self.navigationItem.title = additionalPath // 네비게이션 타이틀 설정. 네비바가 없으면 뷰에는 나타나지 않는다.
    }

    // MARK: - Configure Method
    private func createDataModel() {
        self.viewModel = ScrapListViewModel<LinkVO>()
    }

    private func bindItem() {
        guard let model = self.viewModel else {
            return
        }

        // 뷰모델의 요청 결과에 따라 인디케이터 상태를 변화시킨다.
        isLoading.observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                if $0 {
                    self.networkIndicator.startAnimating()
                    self.networkIndicator.isHidden = false
                } else {
                    self.networkIndicator.stopAnimating()
                    self.networkIndicator.isHidden = true
                }
            }).disposed(by: disposeBag)

        // 뷰모델에서 나오는 데이터를 바인딩한다.
        model.itemsRelay
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .bind(to: self.items)
            .disposed(by: disposeBag)
        
        // 데이터가 새로 들어올 때 마다 테이블 뷰를 리로드한다.
        items.observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
            }).disposed(by: disposeBag)

        // 뷰모델의 요청 결과에 따라 네트워크 인디케이터를 끄거나, 경고창을 띄운다.
        model.requestRelay
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe (onNext:{ (isSuccess, _) in

                self.isLoading.accept(false)

                if !isSuccess  {
                    let alert = UIAlertController
                        .getAlert(withTitle: "네트워크 오류",
                                  message: "인터넷 연결 상태를 다시 확인해주세요") { _ in
                                    self.isLoading.accept(true)
                                    self.commandToViewModel()
                    }
                    self.present(alert, animated: true)
                }
            }).disposed(by: disposeBag)
    }

    private func bindTableViewDelegate() {
        // delegate, datasource, prefetchingDatasource와 데이터를 바인딩한다.
        self.items
            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .bind(to: tableViewDelegate.itemRelay,
                  tableViewDatasource.itemRelay,
                  tableViewDataSourcePrefetching.itemRelay)
            .disposed(by: disposeBag)

        // 테이블뷰에 delegate와 datasource를 세팅한다.
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDatasource
        self.tableView.prefetchDataSource = tableViewDataSourcePrefetching
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshBySwipeDown), for: .valueChanged)
    }

    private func commandToViewModel() {
        let command = GIGCollectionScrapCommand(additionalPath: additionalPath)

        self.viewModel?.command = command
    }
    
    // MARK: - Action Method
    @objc private func refreshBySwipeDown() {
        commandToViewModel()

        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Deinit
    deinit {
        disposeBag = DisposeBag()
    }
}
