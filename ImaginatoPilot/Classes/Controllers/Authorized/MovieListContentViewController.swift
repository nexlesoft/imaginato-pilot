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
    @IBOutlet weak var titleLabel: UILabel!
    var pageIndex: Int = 0
    var viewModel = MovieListViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if pageIndex == 0 {
            titleLabel.text = "Showing"
        } else {
            titleLabel.text = "Coming soon"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
