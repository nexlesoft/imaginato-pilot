//
//  Utils.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//


import UIKit
import CoreImage
import SVProgressHUD

class Utils: NSObject {
    class func showIndicator() {
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor(hex: "#f2645a"))
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    class func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    class func isEmpty(_ stringCheck:String)->Bool {
        if stringCheck.isEmpty || stringCheck.isBlank() {
            return true
        }
        let stringTemp =  stringCheck.replacingOccurrences(of: " ", with: "", options: [], range: nil)
        if stringTemp == "" {
            return true
        }
        return false
    }
}

