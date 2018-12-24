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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("----------------------------viewDidAppear:", self.classForCoder);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: - Utility func

extension BaseViewController {
    func getViewController(storyboardName: String?, className: String?) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName ?? "", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: className ?? "")
        return vc
    }

    @IBAction func dismissKeyBoardAction(sender: Any) {
        self.view.endEditing(true)
    }
    
}

