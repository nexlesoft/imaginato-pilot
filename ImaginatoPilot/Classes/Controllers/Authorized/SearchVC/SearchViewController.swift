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


class SearchViewController: BaseViewController {
    
    @IBOutlet weak var navibarCustom: UIView!
    @IBOutlet weak var vSearch: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightNavibarCustomContaint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableViewContraint: NSLayoutConstraint!
    var listHistory:NSMutableArray = NSMutableArray()
    var searchViewModel:HistorySearchViewModel?
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNotificationCenter()
        self.searchViewModel = HistorySearchViewModel()
        if let viewModel = self.searchViewModel {
            self.bindHistorySearchList(with: viewModel)
            self.setupTableViewCellWhenTapped(with: viewModel)
            self.setupTableViewCellWhenDeleted(with: viewModel)
        }
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
        NotificationCenter.default.removeObserver(self)
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
    
    private func saveDataSearch() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.listHistory)
        UserDefaults.standard.setValue(data, forKey: keyListHistory)
        UserDefaults.standard.synchronize()
    }
    
    private func moveToMovieList(strSearch:String) {
        if let movieListVC = self.getViewController(storyboardName: "Main", className: "MovieListViewController") as? MovieListViewController {
            let keyword = strSearch
            movieListVC.keyword = keyword
            self.navigationController?.pushViewController(movieListVC, animated: true)
            self.searchViewModel?.addTodo(withStr: keyword)
        }
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
    }
    
    private func bindHistorySearchList(with viewModel: HistorySearchViewModel) {
        viewModel.listSearchHistorys.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) { (row, element, cell) in
            print("element === >>>> ",element)
            cell.titleLabel.text = element as? String
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCellWhenTapped(with viewModel: HistorySearchViewModel) {
        self.tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false)
                let keyword = viewModel.listSearchHistorys.value[indexPath.row] as? String ?? ""
                self?.moveToMovieList(strSearch: keyword)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCellWhenDeleted(with viewModel: HistorySearchViewModel) {
        self.tableView.rx.itemDeleted
            .subscribe(onNext : {[weak self] indexPath in
                print(indexPath)
                guard let owner = self else {return}
                owner.searchViewModel?.removeHistorySearch(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
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
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTable
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action =  UIContextualAction(style: .normal, title: "", handler: { [weak self](action,view,completionHandler ) in
            guard let owner = self else {return}
//            self?.listHistory.removeObject(at: indexPath.row)
//            self?.saveDataSearch()
//            self?.tableView.reloadData()
            owner.tableView.dataSource?.tableView!(owner.tableView , commit: .delete, forRowAt: indexPath)
        })
        action.image = UIImage(named: "icon_delete")
        action.backgroundColor = .gray
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let strSearch = self.listHistory[indexPath.row] as? String ?? ""
//        self.tfSearch.text = ""
//        self.moveToMovieList(strSearch: strSearch)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}

// MARK: UITextFieldDelegate
extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        }
        self.moveToMovieList(strSearch: textField.text ?? "")
        return true
    }
}
