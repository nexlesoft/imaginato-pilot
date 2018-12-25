//
//  MovieListViewModel2.swift
//  ImaginatoPilot
//
//  Created by Apple on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

enum MovieListType: String {
    case Showing
    case Upcoming
}

enum MovieTableViewCellType {
    case normal(cellViewModel: MovieViewModel)
    case error(message: String)
    case empty
}

class MovieListViewModel {
    
    let searchText = Variable("")
    static var offset = 20
    let disposeBag = DisposeBag()
    let baseWebServices: BaseWebServices
    
    init(baseWebServices: BaseWebServices = BaseWebServices()) {
        self.baseWebServices = baseWebServices
    }
    var movieCells: Observable<[MovieTableViewCellType]> {
        return cells.asObservable()
    }
    private let cells = Variable<[MovieTableViewCellType]>([])
    
    func fetchMovieList() {
        baseWebServices.getMovieList(path: "search?keyword=\("s")&offset=\(MovieListViewModel.offset)")
            .subscribe(onNext: { [weak self] (movies) in
                guard movies.count > 0 else {
                    self?.cells.value = [.empty]
                    return
                }
                self?.cells.value = movies.compactMap { .normal(cellViewModel: MovieViewModel(movie: $0 )) }
            }, onError: { (error) in
                //
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func resetOffset() {
        MovieListViewModel.offset = 20
    }
}
