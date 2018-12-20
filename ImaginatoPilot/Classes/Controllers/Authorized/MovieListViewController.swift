//
//  MovieListViewController.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift

class MovieListViewController: BaseViewController {
    
    var keyword = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableView1: UITableView!
    var viewModel = MovieListViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showingData
            .drive(tableView.rx.items(cellIdentifier: "Cell2")) { _, movie, cell in
                cell.textLabel?.text = movie.title
                cell.detailTextLabel?.text = movie.id
            }
            .disposed(by: disposeBag)

        viewModel.upcomingData
            .drive(tableView1.rx.items(cellIdentifier: "Cell3")) { _, movie, cell in
                cell.textLabel?.text = movie.title
                cell.detailTextLabel?.text = movie.id
            }
            .disposed(by: disposeBag)
        
        let obsKeyword = Observable<String>.just("s")
        obsKeyword.bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("Deinit MovieListViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let obsKeyword = Observable<String>.just(keyword)
//        obsKeyword.bind(to: viewModel.searchText)
//            .disposed(by: disposeBag)
    }
}

// MARK: User Interaction
extension MovieListViewController {
    
}
