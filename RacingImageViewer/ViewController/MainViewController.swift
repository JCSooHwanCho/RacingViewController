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

class MainViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewDelegate = MainTableViewDelegate()
    let tableViewDataSource = MainTableViewDatasource()
    let tableViewPrefetchingDataSource = MainTableViewPrefetcingDatasource()
    
    // MARK:- Property
    var disposeBag = DisposeBag()
    var dataModel: SequenceDataModel<ImageVO>?
    private var items: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    let requestURL = "http://www.gettyimagesgallery.com/collection/auto-racing/"
    
    // MARK:- VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDataModel()
        bindTableViewDelegate()
        bindItem()
    }
    
    // MARK:- Configure Method
    private func createDataModel() {
        let command = GIGCollectionScrapingCommand()
        command.addPath("auto-racing")
        
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
            .disposed(by:disposeBag)
    }
    
    private func bindTableViewDelegate() {
        guard let model = self.dataModel else {
            return
        }
        
        model.relay
            .bind(to: self.tableViewDelegate.itemRelay)
            .disposed(by: disposeBag)
        model.relay
            .bind(to:self.tableViewDataSource.itemRelay)
            .disposed(by: disposeBag)
        model.relay
            .bind(to: self.tableViewPrefetchingDataSource.itemRelay)
            .disposed(by: disposeBag)
        
        tableView.dataSource = self.tableViewDataSource
        tableView.delegate = self.tableViewDelegate
        tableView.prefetchDataSource = self.tableViewPrefetchingDataSource
    }
    
    // MARK:- Deinit
    deinit {
        disposeBag = DisposeBag()
    }
}
