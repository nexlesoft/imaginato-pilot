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
        
//        let obsKeyword = Observable<String>.just("s")
//        obsKeyword.bind(to: viewModel.searchText)
//            .disposed(by: disposeBag)
//        viewModel?.showingData
//            .drive(tableView.rx.items(cellIdentifier: "MovieListCell")) { _, movie, cell in
//                if let movieCell = cell as? MovieListCell {
//                    movieCell.titleLabel.text = movie.title
//                }
////                cell.textLabel?.text = movie.title
////                cell.detailTextLabel?.text = movie.id
//            }
//            .disposed(by: disposeBag)
        
//        viewModel.showingData.drive(onNext: { (movies) in
//            for movie in movies {
//                //
//            }
//        }, onCompleted: nil, onDisposed: nil)
//        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let obsKeyword = Observable<String>.just(self.keyword)
        obsKeyword.bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        if pageIndex == 0 {
            viewModel.showingData
                .drive(tableView.rx.items(cellIdentifier: "MovieListCell")) { _, movie, cell in
                    if let movieCell = cell as? MovieListCell {
                        movieCell.titleLabel.text = movie.title
                        movieCell.posterImage.layer.cornerRadius = 4
//                        movieCell.posterImage.sd_setImage(with: URL(string: movie.pos), completed: nil)
                    }
                }
                .disposed(by: disposeBag)
        } else {
            
        }
    }
}
