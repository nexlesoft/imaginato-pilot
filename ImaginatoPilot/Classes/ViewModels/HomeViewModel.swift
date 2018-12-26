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
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    private let loadInProgress = Variable(false)
    var onShowError =  PublishSubject<SingleButtonAlert>()
    let disposeBag = DisposeBag()
    var centeredTitle: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var centeredType: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var centeredIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: -1) {
        didSet {
            do {
                let value = try centeredIndex.value() as Int
                if (value > -1) && (value < self.arrMovie.value.count) {
                    let movie = arrMovie.value[value]
                    try centeredTitle.onNext(movie.displayTitle.value())
                    let type: String = movie.genreIds.map{$0.name ?? ""}.joined(separator: ", ")
                    centeredType.onNext(type)
                }
            } catch  {
                print("Invalid Index.")
            }
        }
    }
    var carousellScroll = BehaviorRelay<Bool>(value: true)
    var movingToSearchPage = BehaviorRelay<Bool>(value: false)
    var previousCenterIndexPath: IndexPath?
    
    let baseWebServices: BaseWebServices
    init(baseWebServices: BaseWebServices) {
        self.baseWebServices = baseWebServices
    }
    
    func fetchMovieList() {
        self.loadInProgress.value = true
        baseWebServices.getMovieList(path: "home", success: { [weak self] (arrMovie) in
            guard let owner = self else { return }
            arrMovie.forEach({ (movie) in
                let vm = MovieViewModel(movie: movie)
                owner.arrMovie.value.append(vm)
            })
            if let completion = owner.completionFetchData {
                completion()
            }
            owner.loadInProgress.value = false
        }) { [weak self] (errorMsg) in
            guard let owner = self else { return }
            owner.loadInProgress.value = false
            let errorAlert = SingleButtonAlert(
                title: "",
                message: errorMsg,
                action: AlertAction(buttonTitle: "OK")
            )
            self?.onShowError.onNext(errorAlert)
        }
    }
}


