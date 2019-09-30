//
//  UIAlertController+Extension.swift
//  RacingImageViewer
//
//  Created by 조수환 on 2019/09/30.
//  Copyright © 2019 조수환. All rights reserved.
//

import Foundation
import UIKit.UIAlertController


extension UIAlertController {
    static func getAlert(withTitle title: String ,message: String, actionHandler: ((UIAlertAction)->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: "확인", style: .default, handler: actionHandler)

        alert.addAction(ok)

        return alert
    }
}
