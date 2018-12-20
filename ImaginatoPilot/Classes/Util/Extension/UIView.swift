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
    
    /**
     create a component for a class, and add it into a container
     @Param componentClass  AnyClass    component class that you want to create
     @Param container       UIView      container that you want to add component into
     */
    public func componentForClass(componentClass:AnyClass, addIntoContainer container:UIView? = nil)->AnyObject
    {
        let classType:NSObject.Type  =   componentClass as! NSObject.Type
        var instance:UIView?   =   nil
        if NSStringFromClass(componentClass) == "UIButton"
        {
            let button:UIButton     =   UIButton(type: .custom)
            button.isExclusiveTouch   =   true
            instance    =   button
        }
        else
        {
            instance =   classType.init() as? UIView
        }
        
        var tempContainer:UIView?   =   container
        if tempContainer == nil
        {
            tempContainer   =   self
        }
        
        tempContainer!.addSubview(instance!)
        return instance!
    }
    
    /**
     deep copy a view
     */
    public func copyView()->AnyObject
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as AnyObject
    }
    
    /**
     draw circle for itself
     */
    public func drawCircle()
    {
        self.layer.cornerRadius  =   self.bounds.width / 2.0
        self.layer.masksToBounds =   true
    }
    
    /**
     draw corner for itself
     */
    public func drawCorner(radius:CGFloat)
    {
        self.layer.cornerRadius     =   (radius == -1) ? self.bounds.width * 0.5 : radius
        self.layer.masksToBounds    =   true
    }
    
    /**
     check a itself and super views is kind of a class
     */
    public func isSelfOrItsParentKindOfClass(classType:AnyClass)->Bool
    {
        if self.isKind(of: classType)
        {
            return true
        }
        
        var parentView:UIView?   =   self.superview
        while parentView != nil && !parentView!.isKind(of: classType)
        {
            parentView  =   parentView!.superview
        }
        
        return (parentView != nil)
    }
    
    /**
     remove all subviews from itself
     */
    public func removeAllSubViews()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }
}
