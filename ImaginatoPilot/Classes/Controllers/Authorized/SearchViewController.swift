//
//  SearchViewController.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BGTableViewRowActionWithImage

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var navibarCustom: UIView!
    @IBOutlet weak var vSearch: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightNavibarCustomContaint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableViewContraint: NSLayoutConstraint!
    var listHistory:NSMutableArray = NSMutableArray()
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
        if let data = UserDefaults.standard.object(forKey: keyListHistory) as? Data {
            if let array =  NSKeyedUnarchiver.unarchiveObject(with: data) as? NSMutableArray {
                self.listHistory = array
                self.tableView.reloadData()
            }
        }
    }
    
    private func saveDataSearch() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.listHistory)
        UserDefaults.standard.setValue(data, forKey: keyListHistory)
        UserDefaults.standard.synchronize()
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
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(hexString: "#A8A8A8")
        cell.textLabel?.text = self.listHistory[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = BGTableViewRowActionWithImage.rowAction(with: .default, title: "     ", backgroundColor: UIColor.gray, image: UIImage(named: "icon_delete"), forCellHeight: UInt(heightTable)) {[weak self] (action, indexPath) in
            if let indexPath = indexPath {
                self?.listHistory.removeObject(at: indexPath.row)
                self?.saveDataSearch()
                self?.tableView.reloadData()
            }
        }
        return [delete!]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tfSearch.text = self.listHistory[indexPath.row] as! String
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: UITextFieldDelegate
extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        }
        let movieListVC = self.getViewController(storyboardName: "Main", className: "MovieListViewController") as! MovieListViewController
        movieListVC.keyword = textField.text ?? ""
        self.navigationController?.pushViewController(movieListVC, animated: true)
        if self.listHistory.count >= 10 {
            self.listHistory.removeLastObject()
        }
        self.listHistory.insert(textField.text ?? "", at: 0)
        self.tableView.reloadData()
        self.tfSearch.text = ""
        self.saveDataSearch()
        textField.resignFirstResponder()
        return true
    }
}
