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
//
        if let response = json as? [String: Any] {
            print("******response: \(response)")
            if let results = response["results"] as? [JSON] {
                print("*****results: \(results)")
            }
            if let results = response["results"] as? NSArray {
                print("*****results2: \(results)")
                for json in results{
                    if let js = json as? JSON {
                        print("*********json: \(js)")
                    }
                    if let js = json as? NSDictionary {
                        print("*********json1: \(JSON(js))")
                    }
                }
            }
        }
        
        var movies = [MovieDTO]()
//        print("********HomeResponse: \(results)")
        results.forEach{
            guard let id = $0["id"] as? String,
                let title = $0["title"] as? String else {
                    return
            }
//            movies.append(Movie(id: id, title: title))
            movies.append(MovieDTO(json: JSON($0)))

        }
        return movies
    }
    
}


