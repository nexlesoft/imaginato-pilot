//
//  Application.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
class Application: NSObject {
    static let sharedInstance : Application = Application()
    override init() {
        super.init()
        self.setup()
    }
}
extension Application {
    func setup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    func animationSwitchScreen(nav: UIViewController!, animation: Bool!) {
        appdelegate.window?.rootViewController = nav
        if animation == true {
            let snapShot = appdelegate.window?.snapshotView(afterScreenUpdates: true)
            nav.view.addSubview(snapShot!)
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                snapShot?.layer.opacity = 0
                snapShot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }) { (finished: Bool) -> Void in
                snapShot?.removeFromSuperview()
            }
        }
    }
    
    func gotoStartScreens() {
        application.switchToMainScreen(animation: true)
    }
    
    func switchToMainScreen(animation: Bool!) {
        let presentedVC = UIApplication.shared.keyWindow?.rootViewController
        if let vC = presentedVC as? UINavigationController {
            if vC.visibleViewController!.isKind(of: UIAlertController.self) {
                vC.dismiss(animated: true, completion: {
                    print("dismissViewControllerAnimated")
                })
            }
        }
        let story = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let mainNav = UINavigationController(rootViewController: mainViewController)
        self.animationSwitchScreen(nav: mainNav, animation: animation)
    }
}

