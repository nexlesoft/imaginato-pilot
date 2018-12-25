//
//  BaseWebServices.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/25/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON

class BaseWebServices {
    
    enum GetMovieFailureReason: Int, Error {
        case notFound = 404
    }
    
    let disposeBag = DisposeBag()
    
    func getMovieList(path: String, success: @escaping ([MovieDTO]) -> Void, failure: @escaping (String) -> Void) {
        RxAlamofire.requestJSON(.get, baseURL + path)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (r, json) -> [String: Any] in
                guard let jsonDict = json as? [String: Any] else {
                    return [:]
                }
                return jsonDict
            }
            .subscribe(onNext: { jsonDict in
                guard let results = jsonDict["results"] as? [[String: Any]] else {
                        success([])
                    return
                }
                var movies = [MovieDTO]()
                results.forEach {
                    movies.append(MovieDTO(json: JSON($0)))
                }
                return success(movies)
            }, onError: { error in
                failure(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getMovieList(path: String) -> Observable<[String: [MovieDTO]]> {
        return Observable.create { observer -> Disposable in
            RxAlamofire.requestJSON(.get, baseURL + path)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .map { (r, json) -> [String: Any] in
                    print("_____________path: \(path), json: \(json)")
                    guard let jsonDict = json as? [String: Any] else {
                        return [:]
                    }
                    return jsonDict
                }
                .subscribe(onNext: { jsonDict in
                    guard let results = jsonDict["results"] as? [String: Any] else {
                        observer.onError(GetMovieFailureReason.notFound)
                        return
                    }
                    
                    var showingMovies = [MovieDTO]()
                    var upcomingMovies = [MovieDTO]()
                    if let showing = results["showing"] as? [[String: Any]] {
                        showing.forEach {
                            showingMovies.append(MovieDTO(json: JSON($0)))
                        }
                    }
                    if let upcoming = results["upcoming"] as? [[String: Any]] {
                        upcoming.forEach {
                            upcomingMovies.append(MovieDTO(json: JSON($0)))
                        }
                    }
                    
                    observer.onNext(["showing": showingMovies, "upcoming": upcomingMovies])
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
