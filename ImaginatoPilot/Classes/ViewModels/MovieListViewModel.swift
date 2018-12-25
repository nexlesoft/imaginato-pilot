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
    
    init(baseWebServices: BaseWebServices = BaseWebServices()) {
        self.baseWebServices = baseWebServices
    }
    var showingMovieCells: Observable<[MovieTableViewCellType]> {
        return showingCells.asObservable()
    }
    var upcomingMovieCells: Observable<[MovieTableViewCellType]> {
        return showingCells.asObservable()
    }
    private let showingCells = Variable<[MovieTableViewCellType]>([])
    private let upcomingCells = Variable<[MovieTableViewCellType]>([])
    func fetchMovieList() {
        
//        appServerClient
//            .getFriends()
//            .subscribe(
//                onNext: { [weak self] friends in
//                    self?.loadInProgress.value = false
//                    guard friends.count > 0 else {
//                        self?.cells.value = [.empty]
//                        return
//                    }
//
//                    self?.cells.value = friends.compactMap { .normal(cellViewModel: FriendCellViewModel(friend: $0 )) }
//                },
//                onError: { [weak self] error in
//                    self?.loadInProgress.value = false
//                    self?.cells.value = [
//                        .error(
//                            message: (error as? AppServerClient.GetFriendsFailureReason)?.getErrorMessage() ?? "Loading failed, check network connection"
//                        )
//                    ]
//                }
//            )
//            .disposed(by: disposeBag)
        baseWebServices.getMovieList(path: "search?keyword=\("s")&offset=\(MovieListViewModel.offset)")
            .subscribe(onNext: { [weak self] (movies) in
                guard movies.count > 0 else {
                    self?.showingCells.value = [.empty]
                    return
                }
                if let showing = movies[MovieListType.showing.rawValue] {
                    self?.showingCells.value = showing.compactMap { .normal(cellViewModel: MovieViewModel(movie: $0 )) }
                }
                if let upcoming = movies[MovieListType.upcoming.rawValue] {
                    self?.showingCells.value = upcoming.compactMap { .normal(cellViewModel: MovieViewModel(movie: $0 )) }
                }
            }, onError: { (error) in
                //
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
    
    
//    lazy var showingData: Driver<[MovieViewModel]> = {
//        return self.searchText.asObservable()
//            .distinctUntilChanged()
//            .flatMapLatest(MovieListViewModel.showingBy)
//            .asDriver(onErrorJustReturn: [])
//    }()
//
//    lazy var upcomingData: Driver<[MovieViewModel]> = {
//
//        return self.searchText.asObservable()
//            .distinctUntilChanged()
//            .flatMapLatest(MovieListViewModel.upcomingBy)
//            .asDriver(onErrorJustReturn: [])
//    }()
    func resetOffset() {
        MovieListViewModel.offset = 20
    }
//    static func showingBy(_ keyword: String) -> Observable<[MovieViewModel]> {
//        guard !keyword.isEmpty,
//            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=\(MovieListViewModel.offset)") else {
//                return Observable.just([])
//        }
//
//        return URLSession.shared.rx.json(url: url)
//            .retry(3)
//            .map(parseShowing)
//    }
//
//    static func upcomingBy(_ keyword: String) -> Observable<[MovieViewModel]> {
//        guard !keyword.isEmpty,
//            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=\(MovieListViewModel.offset)") else {
//                return Observable.just([])
//        }
//
//        return URLSession.shared.rx.json(url: url)
//            .retry(3)
//            .map(parseUpcoming)
//    }
    
//    static func parseShowing(json: Any) -> [MovieViewModel] {
//        guard let response = json as? [String: Any],
//            let results = response["results"] as? [String: Any],
//            let showing = results["showing"] as? [[String: Any]]
//            else {
//                return []
//        }
//
//        var movies = [MovieViewModel]()
//        showing.forEach{
//            let movie = MovieDTO(json: JSON($0))
//            let vm = MovieViewModel()
//            vm.movie = movie
//            movies.append(vm)
//        }
//        return movies
//    }
//
//    static func parseUpcoming(json: Any) -> [MovieViewModel] {
//        guard let response = json as? [String: Any],
//            let results = response["results"] as? [String: Any],
//            let upcoming = results["upcoming"] as? [[String: Any]]
//            else {
//                return []
//        }
//
//        var movies = [MovieViewModel]()
//        upcoming.forEach{
//            let movie = MovieDTO(json: JSON($0))
//            let vm = MovieViewModel()
//            vm.movie = movie
//            movies.append(vm)
//        }
//        return movies
//    }
}
