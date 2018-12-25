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
    var movie: MovieDTO?
    
    init(movie: MovieDTO) {
        self.movie = movie
    }
    
    var displayTitle: BehaviorSubject<String> {
        return BehaviorSubject<String>(value: movie?.title ?? "")
    }
    var posterPath: String {
        return movie?.posterPath ?? ""
    }
    var releaseDate: Int {
        return movie?.releaseDate ?? 0
    }
    var id: BehaviorSubject<String> {
        return BehaviorSubject<String>(value: movie?.id ?? "")
    }
    var presaleFlag: Int {
        return movie?.presaleFlag ?? 0
    }
    var genreIds: [GenreIdsDTO] {
        return movie?.genreIds ?? []
    }
    var ageCategory: BehaviorSubject<String> {
        return BehaviorSubject<String>(value: movie?.ageCategory ?? "")
    }
    var descriptionValue: BehaviorSubject<String> {
        return BehaviorSubject<String>(value: movie?.descriptionValue ?? "")
    }
    var rate: Float {
        return movie?.rate ?? 0.0
    }
}
