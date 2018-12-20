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

enum MovieListType: String {
    case Showing
    case Upcoming
}

class MovieListViewModel {
    
    let searchText = Variable("")
    
    lazy var showingData: Driver<[Movie]> = {
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(MovieListViewModel.showingBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    lazy var upcomingData: Driver<[Movie]> = {
        
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(MovieListViewModel.upcomingBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func showingBy(_ keyword: String) -> Observable<[Movie]> {
        guard !keyword.isEmpty,
            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=20") else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .map(parseShowing)
    }
    
    static func upcomingBy(_ keyword: String) -> Observable<[Movie]> {
        guard !keyword.isEmpty,
            let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/search?keyword=\(keyword)&offset=20") else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .map(parseUpcoming)
    }
    
    static func parseShowing(json: Any) -> [Movie] {
        guard let response = json as? [String: Any],
            let results = response["results"] as? [String: Any],
            let showing = results["showing"] as? [[String: Any]]
            else {
                return []
        }
        
        var movies = [Movie]()
        print("********showing: \(showing)")
        showing.forEach{
            guard let id = $0["id"] as? String,
                let title = $0["title"] as? String else {
                    return
            }
            movies.append(Movie(id: id, title: title))
        }
        return movies
    }
    
    static func parseUpcoming(json: Any) -> [Movie] {
        guard let response = json as? [String: Any],
            let results = response["results"] as? [String: Any],
            let upcoming = results["upcoming"] as? [[String: Any]]
            else {
                return []
        }
        
        var movies = [Movie]()
        print("********upcoming: \(upcoming)")
        upcoming.forEach{
            guard let id = $0["id"] as? String,
                let title = $0["title"] as? String else {
                    return
            }
            movies.append(Movie(id: id, title: title))
        }
        return movies
    }
}


