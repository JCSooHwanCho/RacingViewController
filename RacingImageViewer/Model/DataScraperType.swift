//
//  LinkLoader.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/26.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import RxSwift

protocol DataScraperType {
    func scrapData<VO:StringVOType>(fromURL url: URL, scrapingCommand command: ScrapCommand) ->Observable<[VO]>
}
