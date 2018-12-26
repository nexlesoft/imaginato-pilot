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
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightNavibarCustomContaint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableViewContraint: NSLayoutConstraint!

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
            self.setupDidTouchCancel()
            self.bindTextFieldSearch(with: viewModel)
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
    
    private func moveToMovieList() {
        if let movieListVC = self.getViewController(storyboardName: "Main", className: "MovieListViewController") as? MovieListViewController {
            movieListVC.keyword = self.searchViewModel?.textSearch.value ?? ""
            self.navigationController?.pushViewController(movieListVC, animated: true)
            self.searchViewModel?.addHistorySearh()
        }
        self.tfSearch.resignFirstResponder()
    }
    
    private func bindHistorySearchList(with viewModel: HistorySearchViewModel) {
        viewModel.listSearchHistorys.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) { (row, element, cell) in
            cell.viewModel = element
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCellWhenTapped(with viewModel: HistorySearchViewModel) {
        self.tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] indexPath in
                guard let owner = self else {return}
                owner.tableView.deselectRow(at: indexPath, animated: false)
                viewModel.textSearch = viewModel.listSearchHistorys.value[indexPath.row].titleLable
                owner.moveToMovieList()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCellWhenDeleted(with viewModel: HistorySearchViewModel) {
        self.tableView.rx.itemDeleted
            .subscribe(onNext : {[weak self] indexPath in
                guard let owner = self else {return}
                owner.searchViewModel?.removeHistorySearch(withIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDidTouchCancel() {
        self.btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindTextFieldSearch(with viewModel: HistorySearchViewModel) {
        viewModel.textSearch.asObservable().bind(to: self.tfSearch.rx.text).disposed(by: self.disposeBag)
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
            owner.tableView.dataSource?.tableView?(owner.tableView , commit: .delete, forRowAt: indexPath)
        })
        action.image = UIImage(named: "icon_delete")
        action.backgroundColor = .gray
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
}

// MARK: UITextFieldDelegate
extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            Utils.showAlert(message: "Please enter search text")
            return false
        }
        self.searchViewModel?.textSearch.value = textField.text ?? ""
        self.moveToMovieList()
        return true
    }
}
