//
//  MovieViewModel.swift
//  ImaginatoPilot
//
//  Created by admin on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class MovieViewModel {
    private let movie: MovieDTO
    private let disposeBag = DisposeBag()
    
    init(movie: MovieDTO) {
        self.movie = movie
        id = BehaviorSubject<String>(value: movie.id ?? "")
        displayTitle = BehaviorSubject<String>(value: movie.title ?? "")
        releaseDate = BehaviorSubject<Int>(value: movie.releaseDate ?? 0)
        presaleFlag = BehaviorRelay<Bool>(value: !(movie.presaleFlag ?? false))
        presaleFlag.subscribe(onNext: { (presaleFlag) in
            movie.presaleFlag = !presaleFlag
        }).disposed(by: disposeBag)
        ageCategory = BehaviorSubject<String>(value: movie.ageCategory ?? "")
        descriptionValue = BehaviorSubject<String>(value: movie.descriptionValue ?? "")
        rate = BehaviorSubject<String>(value: "\(movie.rate ?? 0.0)")
    }
    
    let displayTitle: BehaviorSubject<String>
    var posterPath: String {
        return movie.posterPath ?? ""
    }
    
    let releaseDate: BehaviorSubject<Int>

    let id: BehaviorSubject<String>
    let presaleFlag: BehaviorRelay<Bool>
    
    var genreIds: [GenreIdsDTO] {
        return movie.genreIds ?? []
    }

    let ageCategory: BehaviorSubject<String>
    let descriptionValue: BehaviorSubject<String>
    let rate: BehaviorSubject<String>
}
