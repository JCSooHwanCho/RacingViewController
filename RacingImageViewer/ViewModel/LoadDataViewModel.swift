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

      // MARK: - Loading Method
      override func loadData() {
        let loader = CachedLoader()

        guard let command = self.command else {
            return
        }

        let loadObservable: Observable<Element> = loader.loadData(loadCommand: command)

        loadObservable.subscribe { event in
            
        }.disposed(by: disposeBag)
        
      }
}
