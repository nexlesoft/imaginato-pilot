//
//  Utils.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//


import UIKit
import CoreImage
import PKHUD

class Utils: NSObject {
    class func showIndicator() {
        HUD.dimsBackground = true
        HUD.allowsInteraction = false
        HUD.show(.rotatingImage(UIImage(named: "progress_circular")))
    }
    
    class func dismissIndicator() {
        HUD.hide()
    }
    
    class func showAlert(title: String = "", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
        let mainController: UIViewController? = keyWindow?.rootViewController
        mainController?.present(alert, animated: true)
    }
}

