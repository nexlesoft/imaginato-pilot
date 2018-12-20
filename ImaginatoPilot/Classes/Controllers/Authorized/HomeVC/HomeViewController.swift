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
    var carouselTimer : Timer?
    fileprivate var indexCarousel : Int! = 0
    var carousellScroll : Bool! = true
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
    
    fileprivate var arrMovie: [MovieDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.Data.drive(onNext: { [weak self](movies) in
            guard let owner = self else { return }
            owner.arrMovie = movies
            owner.carousel.reloadData()
            owner.autoscrollForBannerView()
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        print("Deinit HomeViewController")
        self.carouselTimer?.invalidate()
        self.carouselTimer = nil
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
        carousel.type = .rotary
        carousel.delegate = self
        carousel.dataSource = self
        lblMovieTitle.text = ""
        lblMovieGenre.text = ""
    }
    
    private func createTimerAutoScroll() {
        self.carouselTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoscrollForBannerView), userInfo: nil, repeats: true)
    }
    
    @objc func autoscrollForBannerView() {
        func autoscroll(_ currentIndex: Int) {
            self.indexCarousel = currentIndex
            if self.carouselTimer == nil {
                 self.createTimerAutoScroll()
            }
        }
        
        if self.carousellScroll == false {
            autoscroll(self.carousel.currentItemIndex)
        } else if self.arrMovie.count > 0 && self.carousel.currentItemIndex < self.carousel.numberOfItems - 1 {
            let nextIndex  = self.carousel.currentItemIndex + 1
            // Get next view
            let view = self.carousel.itemView(at: nextIndex) as? MovieCarouselView
            if let view = view {
                if view.imvPoster.image != nil {
                    self.carousel.scrollToItem(at: nextIndex, animated: true)
                    autoscroll(nextIndex)
                }
                else {
                    autoscroll(nextIndex)
                }
            }
            else {
                autoscroll(nextIndex - 1)
            }
        } else {
            autoscroll(0)
            self.carousel.scrollToItem(at: 0, animated: true)
        }
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
            return movieView
        }
        else {
            let movieView = MovieCarouselView.loadNib()
            let width = carousel.frame.size.width * 2.0 / 3.0
            let height = carousel.frame.size.height
            movieView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            movieView.binData(arrMovie[index])
            return movieView
        }
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex < arrMovie.count && carousel.currentItemIndex >= 0 {
            let movie = arrMovie[carousel.currentItemIndex]
            self.lblMovieTitle.text = movie.title
            if let genre = movie.genreIds?.first {
                self.lblMovieGenre.text = genre.name ?? ""
            }
        }
        
        if self.lblMovieTitle.alpha == 1 {
            UIView.animate(withDuration: 0.2) {
                self.lblMovieTitle.alpha = 0
                self.lblMovieGenre.alpha = 0
            }
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        self.carousellScroll = true
        UIView.animate(withDuration: 0.5) {
            self.lblMovieTitle.alpha = 1
            self.lblMovieGenre.alpha = 1
        }
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if self.arrMovie.count == 0 {return}
        self.carousellScroll = false
    }
    
    func carouselWillBeginDecelerating(_ carousel: iCarousel) {
        self.carousellScroll = false
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        self.carousellScroll = false
        self.carouselTimer?.invalidate()
    }
    
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        self.carousellScroll = false
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        carousel.currentItemView?.alpha = 1
        self.carousellScroll = true
    }
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        self.carousellScroll = true
        self.createTimerAutoScroll()
    }
}
