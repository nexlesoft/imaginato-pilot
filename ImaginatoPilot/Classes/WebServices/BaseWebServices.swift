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
                failure("Error")
            })
            .disposed(by: DisposeBag())
    }
    
}
