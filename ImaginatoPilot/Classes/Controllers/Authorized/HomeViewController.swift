//
//  HomeViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift
class HomeViewController: BaseViewController {
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    @IBAction func didTouchButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        vc.keyword = "s"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.Data
            .drive(tableView.rx.items(cellIdentifier: "Cell4")) { _, movie, cell in
                cell.textLabel?.text = movie.title
                cell.detailTextLabel?.text = movie.id
            }
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("Deinit HomeViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: User Interaction
extension HomeViewController {
    @IBAction func didTouchSearch(_ sender : UIButton) {
        let searchVC = self.getViewController(storyboardName: "Main", className: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

