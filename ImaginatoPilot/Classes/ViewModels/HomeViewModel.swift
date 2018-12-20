//
//  HomeViewModel.swift
//  ImaginatoPilot
//
//  Created by Apple on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class HomeViewModel {
    
    lazy var Data: Driver<[MovieDTO]> = {
        return HomeViewModel.moviesBy()
            .asDriver(onErrorJustReturn: [])
    }()
    
    
    static func moviesBy() -> Observable<[MovieDTO]> {
        if let url = URL(string: "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/home"){
            return URLSession.shared.rx.json(url: url)
                .retry(3)
                .map(parse)
        } else {
            return Observable.just([])
        }
    }
    
    static func parse(json: Any) -> [MovieDTO] {
        guard let response = json as? [String: Any],
            let results = response["results"] as? [[String: Any]]
            else {
                return []
        }
        
        var movies = [MovieDTO]()
        results.forEach{
            movies.append(MovieDTO(json: JSON($0)))
        }
        return movies
    }
    
}


