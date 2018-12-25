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
        presaleFlag = BehaviorRelay<Bool>(value: !(movie.presaleFlag ?? false))
        presaleFlag.subscribe(onNext: { (presaleFlag) in
            movie.presaleFlag = !presaleFlag
        }).disposed(by: disposeBag)
    }
    
    var displayTitle: String {
        return movie.title ?? ""
    }
    
    var posterPath: String {
        return movie.posterPath ?? ""
    }
    
    var releaseDate: Int {
        return movie.releaseDate ?? 0
    }
    var id: String {
        return movie.id ?? ""
    }
    
    let presaleFlag: BehaviorRelay<Bool>
    
    var genreIds: [GenreIdsDTO] {
        return movie.genreIds ?? []
    }
    var ageCategory: String {
        return movie.ageCategory ?? ""
    }
    var descriptionValue: String {
        return movie.descriptionValue ?? ""
    }
    var rate: Float {
        return movie.rate ?? 0.0
    }
}
