//
//  SingleDataLoaderType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

protocol SingleDataLoaderType {
    func loadData<Element>(loadCommand command: SingleDataCommand) -> Observable<Element>
}
