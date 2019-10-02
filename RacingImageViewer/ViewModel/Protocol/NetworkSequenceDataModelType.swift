//
//  NetworkSequenceDataModelProtocol.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/30.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation

// Sequence 데이터를 네트워크를 통해 로딩하는 모델을 나타내는 프로토콜
protocol NetworkSequenceDataModelType: SequenceDataModelType, NetworkStatusModelType { }
