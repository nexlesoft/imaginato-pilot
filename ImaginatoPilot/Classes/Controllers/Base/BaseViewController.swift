//
//  BaseViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit

typealias PushCompletedBlock =  (BaseViewController)-> ()
class BaseViewController: UIViewController , UIGestureRecognizerDelegate {
    
    var pushCompleted: PushCompletedBlock?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("----------------------------viewDidAppear:", self.classForCoder);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pushCompleted = self.pushCompleted {
            pushCompleted(self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if nil != self.pushCompleted {
            self.pushCompleted = nil
        }
    }
}

extension BaseViewController {
    func dismisKeyboard(){
        self.view.endEditing(true)
    }
    
    func disableMutitouch() {
        
        
        self.view.isExclusiveTouch = true
        self.view.isMultipleTouchEnabled = false
        
        for v in self.view.subviews {
            v.isExclusiveTouch = true
            v.isMultipleTouchEnabled = false
        }
    }
    
    func setUpNavigationBar() {
        
        
    }

    func btnBackTouch() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Utility func

extension BaseViewController {
    func getViewController(storyboardName: String!, className: String!) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: className)
        return vc
    }
    
    func pushToViewController(storyboardName: String!, className: String!, animation: Bool!, completed: PushCompletedBlock? = nil) {
        assert(storyboardName.length > 0, "storyboard name cannot null")
        let vc = self.getViewController(storyboardName: storyboardName, className: className)
        self.pushCompleted = completed
        
        if let vctemp = self.navigationController?.viewControllers.last {
            if vctemp.isKind(of: NSClassFromString("ImaginatoPilot."+className)!) {
                return
            }
        }
        if let vct = vc {
            vct.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vct , animated: animation)
        }
        
    }
    
    func parentPushToViewController(toVC: UIViewController?, animation: Bool!, completed: PushCompletedBlock? = nil) {
        self.pushCompleted = completed
        if let vct = toVC {
            vct.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vct , animated: animation)
        }
        
    }
    
    func getViewControllerInStackNavigation(classType: AnyClass) -> UIViewController? {
        var viewController: UIViewController!
        if let navigation = self.navigationController {
            for vc in navigation.viewControllers.reversed() {
                if vc.isKind(of: classType) {
                    viewController = vc
                    break
                }
            }
        }
        
        return viewController
    }
    
    
    @IBAction func dismissKeyBoardAction(sender: Any) {
        self.view.endEditing(true)
    }
    
}

