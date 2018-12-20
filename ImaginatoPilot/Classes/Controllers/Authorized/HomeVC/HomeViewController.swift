//
//  HomeViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift
class HomeViewController: BaseViewController {
    var viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    @IBAction func didTouchButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
        vc.keyword = "s"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet fileprivate weak var carousel: iCarousel!
    @IBOutlet fileprivate weak var lctHeightHeader: NSLayoutConstraint!
    @IBOutlet fileprivate weak var btnSearch: UIButton!
    @IBOutlet fileprivate weak var lblMovieTitle: UILabel!
    @IBOutlet fileprivate weak var lblMovieGenre: UILabel!
    @IBOutlet fileprivate weak var lctRatioCarousel: NSLayoutConstraint!
    
    fileprivate var arrMovie: [MovieDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.Data.drive(onNext: { [weak self](movies) in
            guard let owner = self else { return }
            owner.arrMovie = movies
            owner.carousel.reloadData()
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("Deinit HomeViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: User Interaction
extension HomeViewController {
    @IBAction func didTouchSearch(_ sender : UIButton) {
        let searchVC = self.getViewController(storyboardName: "Main", className: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

//MARK: - Private Func
extension HomeViewController {
    fileprivate func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        lctHeightHeader.constant = Application.sharedInstance.appTopOffset + 44
        carousel.type = .linear
        carousel.delegate = self
        carousel.dataSource = self
        lblMovieTitle.text = ""
        lblMovieGenre.text = ""
    }
}

//MARK: - iCarousel
extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return arrMovie.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if let movieView = view as? MovieCarouselView {
            movieView.binData(arrMovie[index])
            movieView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            movieView.hiddenBuyTicket(true)
            return movieView
        }
        else {
            let movieView = MovieCarouselView.loadNib()
            let width = carousel.frame.size.width * 2.0 / 3.0
            let height = carousel.frame.size.height
            movieView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            movieView.binData(arrMovie[index])
            movieView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            movieView.hiddenBuyTicket(true)
            return movieView
        }
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex < arrMovie.count && carousel.currentItemIndex >= 0 {
            let movie = arrMovie[carousel.currentItemIndex]
            self.lblMovieTitle.text = movie.title
            if let genreIds = movie.genreIds {
                self.lblMovieGenre.text = genreIds.map{$0.name ?? ""}.joined(separator: ", ")
            }
        }
        
        if self.lblMovieTitle.alpha == 1 {
            UIView.animate(withDuration: 0.2) {
                self.lblMovieTitle.alpha = 0
                self.lblMovieGenre.alpha = 0
            }
        }
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        if let currentView = carousel.itemView(at: carousel.currentItemIndex) as? MovieCarouselView {
            currentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            currentView.hiddenBuyTicket(true)
        }
    }
    
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        if let currentView = carousel.itemView(at: carousel.currentItemIndex) as? MovieCarouselView {
            currentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            currentView.hiddenBuyTicket(true)
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if let currentView = carousel.itemView(at: carousel.currentItemIndex) as? MovieCarouselView {
            currentView.transform = .identity
            currentView.hiddenBuyTicket(false)
        }
        UIView.animate(withDuration: 0.5) {
            self.lblMovieTitle.alpha = 1
            self.lblMovieGenre.alpha = 1
        }
    }
}
