//
//  SearchViewController.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage
class SearchViewController: BaseViewController {
    
    @IBOutlet weak var navibarCustom: UIView!
    @IBOutlet weak var vSearch: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightNavibarCustomContaint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableViewContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNotificationCenter()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    deinit {
        print("Deinit SearchViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: Private Func
extension SearchViewController {
    private func setupView() {
        self.vSearch.layer.cornerRadius = self.vSearch.frame.height / 2
        self.vSearch.clipsToBounds = true
        self.tfSearch.becomeFirstResponder()
        self.tfSearch.delegate = self
        let heightOfStatusBar = UIApplication.shared.statusBarFrame.size.height
        let heightOfNavibar = self.navigationController?.navigationBar.frame.size.height
        self.heightNavibarCustomContaint.constant = heightOfNavibar! + heightOfStatusBar
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomTableViewContraint.constant = 0
            } else {
                self.bottomTableViewContraint.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

// MARK: User Interaction
extension SearchViewController {
    @IBAction func didTouchCancel(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SearchViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(hexString: "#A8A8A8")
        cell.textLabel?.text = "GPThanh + \( indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = BGTableViewRowActionWithImage.rowAction(with: .default, title: "     ", backgroundColor: UIColor.gray, image: UIImage(named: "icon_delete"), forCellHeight: 40) { (action, indexPath) in
            
        }
        return [delete!]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        let movieListVC = self.getViewController(storyboardName: "Main", className: "MovieListViewController") as! MovieListViewController
        self.navigationController?.pushViewController(movieListVC, animated: true)
        textField.resignFirstResponder()
        return true
    }
}
