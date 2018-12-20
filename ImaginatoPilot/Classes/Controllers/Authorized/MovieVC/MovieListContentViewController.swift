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

    override func viewDidLoad() {
        super.viewDidLoad()
        if pageIndex == 0 {
            
        } else {
            
        }
//        viewModel.showingData
//            .drive(tableView.rx.items(cellIdentifier: "Cell2")) { _, movie, cell in
//                cell.textLabel?.text = movie.title
//                cell.detailTextLabel?.text = movie.id
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
}
