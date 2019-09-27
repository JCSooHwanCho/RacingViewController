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
import Kanna

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
    
    // MARK:- VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDataModel()
        bindItem()
        bindTableView()
    }
    
    // MARK:- Configure Method
    private func createDataModel() {
        let baseURL = "http://www.gettyimagesgallery.com/collection/auto-racing/"
        self.dataModel = ScrapListModel<ImageVO>(withURL: baseURL) { htmlText in
            let doc = try HTML(html: htmlText,encoding: .utf8)
                            
            let selector = try CSS.toXPath("div[class=grid-item image-item col-md-4]")
            
            var arr: [ImageVO] = []
            for node in doc.xpath(selector) {
                if let imageNode = node.at_css("img") {
                    if let imageURL = imageNode["data-src"] {
                        
                        let httpURL = imageURL.replacingOccurrences(of: "https://", with: "http://") // http요청을 위해 https를 http로 바꾼다.
                        let image = ImageVO(imageURL: httpURL)
                        arr.append(image)
                    }
                }
            }
            return arr
        }
    }
    
    private func bindItem() {
        guard let model = self.dataModel else {
            return
        }
        
        model.relay
            .bind(to: self.items)
            .disposed(by:disposeBag)

        self.items
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
            self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
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
