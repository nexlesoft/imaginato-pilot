//
//  Font.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit

extension UIFont {
    static internal func sanFranciscoLight(size:CGFloat)->UIFont {
        return   UIFont(name: "SanFranciscoText-Light", size: size)!
    }
    
    static internal func sanFranciscoLightItalict(size:CGFloat)->UIFont {
        return   UIFont(name: "SanFranciscoText-LightItalict", size: size)!
    }
    
    static internal func sanFranciscoLightMedium(size:CGFloat)->UIFont {
        return   UIFont(name: "SanFranciscoText-Medium", size: size)!
    }
    
    static internal func sanFranciscoLightRegular(size:CGFloat)->UIFont {
        return   UIFont(name: "SanFranciscoText-Regular", size: size)!
    }
}
