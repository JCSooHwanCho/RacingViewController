//
//  SingleDataCommandType.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/10/03.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

protocol SingleDataCommandType {

    var baseURL: String { get } // 요청을 넣는 기본 URL

    var additionalPath: String { get set } // 요청을 넣는 세부 경로

    func execute<Element>() throws -> Element? // 실제 데이터를 가져오는 메소드
}

extension SingleDataCommandType {
    var requestURL: URL? { // baseURL + additionalPath로 실제로 사용할 URL을 구성한다.
        guard let url = URL(string: baseURL + additionalPath) else {
            return nil
        }
        return url
    }
}
