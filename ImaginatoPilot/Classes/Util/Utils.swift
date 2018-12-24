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

