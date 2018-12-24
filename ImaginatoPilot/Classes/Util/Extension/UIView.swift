//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    public var firstResponder:UIView?{
        if self.isFirstResponder
        {
            return self
        }
        for subView:UIView in self.subviews
        {
            if let tempFirstResponder   =   subView.firstResponder
            {
                return tempFirstResponder
            }
        }
        return nil
    }
}
