//
//  LoadDataViewModel.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

class LoadDataViewModel<Element:VO>: NetworkSingleDataViewModel<Element> {

    var command: LoadCommand? {
        didSet {
            self.loadData()
        }
    }
    var disposeBag = DisposeBag()

      // MARK: - Initializer
  init(loadCommand command: LoadCommand) {
      super.init()

      self.command = command
      self.loadData()
  }

      // MARK: - Loading Method
      override func loadData() {


      }

      deinit {
           disposeBag = DisposeBag()
      }
}
