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
    case showing
    case upcoming
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
    var sectionIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    var showingButtonColor: BehaviorSubject<UIColor> = BehaviorSubject<UIColor>(value: .black)
    var upcomingButtonColor: BehaviorSubject<UIColor> = BehaviorSubject<UIColor>(value: .black)
    var showingLineIsHidden: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    var upcomingLineIsHidden: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    
    init(baseWebServices: BaseWebServices = BaseWebServices()) {
        self.baseWebServices = baseWebServices
    }
    var showingMovieCells: Observable<[MovieTableViewCellType]> {
        return showingCells.asObservable()
    }
    var upcomingMovieCells: Observable<[MovieTableViewCellType]> {
        return upcomingCells.asObservable()
    }
    private let showingCells = Variable<[MovieTableViewCellType]>([])
    private let upcomingCells = Variable<[MovieTableViewCellType]>([])
    private let loadInProgress = Variable(false)
    
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    func setIndex(_ index: Int) {
        self.sectionIndex.onNext(index)
    }

    func fetchMovieList(keyword: String) {
        let keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        loadInProgress.value = true
        baseWebServices.getMovieList(path: "search?keyword=\(keyword)&offset=\(MovieListViewModel.offset)")
            .subscribe(onNext: { [weak self] (movies) in
                self?.loadInProgress.value = false
                guard movies.count > 0 else {
                    self?.showingCells.value = [.empty]
                    self?.upcomingCells.value = [.empty]
                    return
                }
                if let showing = movies[MovieListType.showing.rawValue] {
                    self?.showingCells.value = showing.compactMap { .normal(cellViewModel: MovieViewModel(movie: $0 )) }
                }
                if let upcoming = movies[MovieListType.upcoming.rawValue] {
                    self?.upcomingCells.value = upcoming.compactMap { .normal(cellViewModel: MovieViewModel(movie: $0 )) }
                }
            }, onError: { [weak self] (error) in
                self?.loadInProgress.value = false
                Utils.showAlert(message: error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func resetOffset() {
        MovieListViewModel.offset = 20
    }
}
