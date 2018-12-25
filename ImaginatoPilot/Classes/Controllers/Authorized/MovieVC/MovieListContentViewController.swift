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
        self.tableView.delegate = self
        let obsKeyword = Observable<String>.just(self.keyword)
        obsKeyword.bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        self.bindViewModel()
        viewModel.fetchMovieList()
    }
    
    func bindViewModel() {
        viewModel.movieCells.bind(to: self.tableView.rx.items) { tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else {
                    return UITableViewCell()
                }
                cell.viewModel = viewModel
                return cell
            case .error(let message):
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = message
                return cell
            case .empty:
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "No data available"
                return cell
            }
            }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension MovieListContentViewController: UITableViewDelegate {
    // Remove separator lines in empty table view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
