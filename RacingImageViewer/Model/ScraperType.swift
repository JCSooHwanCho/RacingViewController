//
//  LinkLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

// 특정 URL에서 ScrapCommand를 이용해 데이터를 Scrap하는 Scraper를 나타내는 프로토콜
protocol ScraperType {
    func scrapData<Element: VO>(scrapingCommand command: SequenceDataCommand) ->Observable<[Element]>
}
