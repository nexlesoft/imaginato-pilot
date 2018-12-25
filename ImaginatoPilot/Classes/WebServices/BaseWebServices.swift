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
    
    func getMovieList(path: String) -> Observable<[MovieDTO]> {
        return Observable.create { observer -> Disposable in
            RxAlamofire.requestJSON(.get, baseURL + path)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .map { (r, json) -> [String: Any] in
                    print("__________path: \(path), json: \(json)")
                    guard let jsonDict = json as? [String: Any] else {
                        return [:]
                    }
                    return jsonDict
                }
                .subscribe(onNext: { jsonDict in
                    if let success = jsonDict["success"] {
                        print("Get movie list success")
                    } else {
                        // Currently there's no error message returned from API so we use default description
                        let error = NSError(domain: "FailureResponse", code: 201, userInfo: nil)
                        observer.onError(error)
                        return
                    }
                    guard let results = jsonDict["results"] as? [String: Any],
                    let showing = results["showing"] as? [[String: Any]]
                        else {
                        observer.onNext([])
                        return
                    }
                    var movies = [MovieDTO]()
                    showing.forEach {
                        movies.append(MovieDTO(json: JSON($0)))
                    }
                    observer.onNext(movies)
                }, onError: { error in
                    observer.onError(error)
                })
        }
    }
    
}
