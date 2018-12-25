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
    var arrMovie = Variable<[MovieDTO]>([])
    var completionFetchData: (()->())?
    
    let baseWebServices: BaseWebServices
    init(baseWebServices: BaseWebServices) {
        self.baseWebServices = baseWebServices
    }
    
    func fetchMovieList() {
        baseWebServices.getMovieList(path: "home", success: { (arrMovie) in
            self.arrMovie.value = arrMovie
            if let completion = self.completionFetchData {
                completion()
            }
        }) { (errorMsg) in
            Utils.showAlert(message: errorMsg)
        }
    }
}


