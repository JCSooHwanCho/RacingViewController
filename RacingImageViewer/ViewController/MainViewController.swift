//
//  ViewController.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/25.
//  Copyright © 2019 조수환. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class MainViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Property
    var disposeBag = DisposeBag()
    private var items: BehaviorRelay<[ImageVO]> = BehaviorRelay(value: [])
    
    // MARK:- VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindItem()
    }
    
    // MARK:- Configure Method
    private func bindItem() {
        let viewModel = ImageListViewModel()
        viewModel.relay
        .bind(to: self.items)
            .disposed(by:disposeBag)
        
        self.items
            .subscribe(onNext: { _ in
            self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    // MARK:- Deinit
    deinit {
        disposeBag = DisposeBag()
    }
    
}

// MARK:- TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath)
        
        guard let imageCell = cell as? ImageTableViewCell else {
            return cell
        }
        
        let itemList = self.items.value
        imageCell.configureCell(tableView,imageData: itemList[indexPath.row], cellForRowAt:indexPath)
        
        return imageCell
    }
}

// MARK:- TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let itemList = self.items.value
        guard let (_,size) = ImageCache.shared[itemList[indexPath.row].imageURL] else { // 아직 캐싱되지 않은 경우
            return UITableView.automaticDimension
        }
        
        let safeAreaSize = self.view.safeAreaLayoutGuide.layoutFrame.size
        return (safeAreaSize.width * size.height)/size.width
    }
}

