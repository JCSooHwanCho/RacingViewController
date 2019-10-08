//
//  DataLoaderType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

protocol DataLoaderType {
    // 주어진 URL에서 데이터를 가져온다.
    func loadData(withURL url: URL) -> Observable<Data>
}
