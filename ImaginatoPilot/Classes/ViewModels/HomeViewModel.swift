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
    var arrMovie = Variable<[MovieViewModel]>([])
    var completionFetchData: (()->())?
    
    let disposeBag = DisposeBag()
    
    var centeredTitle: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var centeredType: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var centeredIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: -1) {
        didSet {
            do {
                let value = try centeredIndex.value() as Int
                if (value > -1) && (value < self.arrMovie.value.count) {
                    let movie = arrMovie.value[value]
                    centeredTitle.onNext(movie.displayTitle)
                    let type: String = movie.genreIds.map{$0.name ?? ""}.joined(separator: ", ")
                    centeredType.onNext(type)
                }
            } catch  {
                print("Invalid Index.")
            }
        }
    }
    
    let baseWebServices: BaseWebServices
    init(baseWebServices: BaseWebServices) {
        self.baseWebServices = baseWebServices
    }
    
    func fetchMovieList() {
        baseWebServices.getMovieList(path: "home", success: { (arrMovie) in
            arrMovie.forEach({ (movie) in
                let vm = MovieViewModel(movie: movie)
                self.arrMovie.value.append(vm)
            })
            if let completion = self.completionFetchData {
                completion()
            }
        }) { (errorMsg) in
            Utils.showAlert(message: errorMsg)
        }
    }
}


