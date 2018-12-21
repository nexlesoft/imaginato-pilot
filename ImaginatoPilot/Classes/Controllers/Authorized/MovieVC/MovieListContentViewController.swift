//
//  MovieListContentViewController.swift
//  ImaginatoPilot
//
//  Created by admin on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift
class MovieListContentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int = 0
    var viewModel = MovieListViewModel()
    let disposeBag = DisposeBag()
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        let obsKeyword = Observable<String>.just(self.keyword)
        obsKeyword.bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        Utils.showIndicator()
        
        if pageIndex == 0 {
            viewModel.showingData
                .drive(tableView.rx.items(cellIdentifier: "MovieListCell")) { _, movie, cell in
                    if let movieCell = cell as? MovieListCell {
                        movieCell.loadFromMovie(movie: movie)
                    }
                    Utils.dismissIndicator()
                }
                .disposed(by: disposeBag)
            viewModel.showingData.drive(onNext: nil, onCompleted: {
                Utils.dismissIndicator()
            }, onDisposed: nil)
            .disposed(by: self.disposeBag)
        } else {
            viewModel.upcomingData
                .drive(tableView.rx.items(cellIdentifier: "MovieListCell")) { _, movie, cell in
                    if let movieCell = cell as? MovieListCell {
                        movieCell.loadFromMovie(movie: movie)
                    }
                    Utils.dismissIndicator()
                }
                .disposed(by: disposeBag)
            viewModel.upcomingData.drive(onNext: nil, onCompleted: {
                Utils.dismissIndicator()
            }, onDisposed: nil)
                .disposed(by: self.disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
