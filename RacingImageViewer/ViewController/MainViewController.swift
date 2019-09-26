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

    @IBOutlet weak var tableView: UITableView!
    
    private var items: [ImageVO] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = UITableView.automaticDimension
        bindItem()
    }
    
    private func bindItem() {
        let viewModel = ImageListViewModel()
        viewModel.relay
            .subscribe { event in
                
                switch event {
                case let .next(value):
                    self.items = value
                default:
                    break;
                }
                
        }.disposed(by: disposeBag)
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath)
        
        guard let imageCell = cell as? ImageTableViewCell else {
            return cell
        }

        imageCell.configureCell(tableView,imageData: self.items[indexPath.row], cellForRowAt:indexPath)
        
        return imageCell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let (_,size) = ImageCache.shared[self.items[indexPath.row].imageURL] else {
            return UITableView.automaticDimension
        }
        
        let safeAreaSize = self.view.safeAreaLayoutGuide.layoutFrame.size
        return (safeAreaSize.width * size.height)/size.width
    }
}
