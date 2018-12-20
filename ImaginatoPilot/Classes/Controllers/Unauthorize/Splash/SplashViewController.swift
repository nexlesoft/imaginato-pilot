//
//  SplashViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
class SplashViewController: BaseViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.delegate = self
        self.gotoNextScreen()
    }
    
    deinit {
        print("deinit SplashViewController")
    }
    
    func gotoNextScreen() {
        application.gotoStartScreens()
    }
}

//MARK: - Life cycle

extension SplashViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SplashViewController: UINavigationControllerDelegate {
    // modify some animation push viewcontroller
}

