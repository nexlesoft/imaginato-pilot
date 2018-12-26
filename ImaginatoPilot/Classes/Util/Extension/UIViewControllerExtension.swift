//
//  UIViewControllerExtension.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/26/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}
