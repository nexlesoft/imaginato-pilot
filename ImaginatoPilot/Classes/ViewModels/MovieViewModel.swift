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
    var displayTitle: String {
        return movie?.title ?? ""
    }
    var posterPath: String {
        return movie?.posterPath ?? ""
    }
    var releaseDate: Int {
        return movie?.releaseDate ?? 0
    }
    var id: String {
        return movie?.id ?? ""
    }
    var presaleFlag: Int {
        return movie?.presaleFlag ?? 0
    }
    var genreIds: [GenreIds] {
        return movie?.genreIds ?? []
    }
    var ageCategory: String {
        return movie?.ageCategory ?? ""
    }
    var descriptionValue: String {
        return movie?.descriptionValue ?? ""
    }
    var rate: Float {
        return movie?.rate ?? 0.0
    }
}
