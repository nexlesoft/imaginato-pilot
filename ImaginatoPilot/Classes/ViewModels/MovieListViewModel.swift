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

class MovieListViewModel {
    
    let searchText = Variable("")
    static var offset = 20
    
    lazy var showingData: Driver<[MovieDTO]> = {
        return self.searchText.asObservable()
            .distinctUntilChanged()
            .flatMapLatest(MovieListViewModel.showingBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    lazy var upcomingData: Driver<[MovieDTO]> = {
        
        return self.searchText.asObservable()
            .distinctUntilChanged()
            .flatMapLatest(MovieListViewModel.upcomingBy)
            .asDriver(onErrorJustReturn: [])
    }()
    func resetOffset() {
        MovieListViewModel.offset = 20
    }
    static func showingBy(_ keyword: String) -> Observable<[MovieDTO]> {
        guard !keyword.isEmpty,
            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=\(MovieListViewModel.offset)") else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .map(parseShowing)
    }
    
    static func upcomingBy(_ keyword: String) -> Observable<[MovieDTO]> {
        guard !keyword.isEmpty,
            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=\(MovieListViewModel.offset)") else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .map(parseUpcoming)
    }
    
    static func parseShowing(json: Any) -> [MovieDTO] {
        guard let response = json as? [String: Any],
            let results = response["results"] as? [String: Any],
            let showing = results["showing"] as? [[String: Any]]
            else {
                return []
        }
        
        var movies = [MovieDTO]()
        showing.forEach{
            movies.append(MovieDTO(json: JSON($0)))
        }
        return movies
    }
    
    static func parseUpcoming(json: Any) -> [MovieDTO] {
        guard let response = json as? [String: Any],
            let results = response["results"] as? [String: Any],
            let upcoming = results["upcoming"] as? [[String: Any]]
            else {
                return []
        }
        
        var movies = [MovieDTO]()
        upcoming.forEach{
            movies.append(MovieDTO(json: JSON($0)))
        }
        return movies
    }
}


