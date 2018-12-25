//
//  HomeViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift
import ScalingCarousel
import RxCocoa
import Swinject
import SwinjectStoryboard

class HomeViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var carousel: ScalingCarouselView!
    @IBOutlet fileprivate weak var lctHeightHeader: NSLayoutConstraint!
    @IBOutlet fileprivate weak var btnSearch: UIButton!
    @IBOutlet fileprivate weak var lblMovieTitle: UILabel!
    @IBOutlet fileprivate weak var lblMovieGenre: UILabel!
    
    fileprivate var previousCenterIndexPath: IndexPath?
    fileprivate var carousellScroll : Bool = true
    fileprivate var carouselTimer : Timer?
    fileprivate var movingToSearchPage: Bool = false
    
    let disposeBag = DisposeBag()
    var viewModel:HomeViewModel? = SwinjectStoryboard.getContainer().resolve(HomeViewModel.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let viewModel = viewModel {
            bindMovieList(with: viewModel)
            setupCollectionViewWhenTap(with: viewModel)
            setupDidScroll(with: viewModel)
            viewModel.fetchMovieList()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movingToSearchPage = false
        if let previoursIndexPath = self.previousCenterIndexPath {
            print("previours IndexPath: \(previoursIndexPath.row)")
            self.carousel.scrollToItem(at: previoursIndexPath, at: .centeredHorizontally, animated: false)
        }
        if let viewModel = self.viewModel {
            if viewModel.arrMovie.value.count > 0 {
                self.createTimerAutoScroll()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.carouselTimer?.invalidate()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carousel.deviceRotated()
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
        self.movingToSearchPage = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

//MARK: - Private Func
extension HomeViewController {
    fileprivate func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        lctHeightHeader.constant = Application.sharedInstance.appTopOffset + 44
        lblMovieTitle.text = ""
        lblMovieGenre.text = ""
        carousel.register(UINib(nibName: "MovieCarouselCell", bundle: nil), forCellWithReuseIdentifier: "MovieCarouselCell")
    }
    
    fileprivate func createTimerAutoScroll() {
        if let timer = self.carouselTimer {
            timer.invalidate()
        }
        self.carouselTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoscrollForBannerView), userInfo: nil, repeats: true)
    }
    
    @objc func autoscrollForBannerView() {
        guard let currentIndex = self.carousel.currentCenterCellIndex, let viewModel = self.viewModel, viewModel.arrMovie.value.count > 0 else {
            return
        }
        if self.carousellScroll == false {
            self.carousel.scrollToItem(at: IndexPath(row: currentIndex.row, section: 0), at: .centeredHorizontally, animated: true)
        } else if viewModel.arrMovie.value.count > 0 && currentIndex.row < viewModel.arrMovie.value.count - 1 {
            let nextIndex  = currentIndex.row + 1
            self.carousel.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)

        }
        else {
            self.carousel.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    fileprivate func bindMovieList(with viewModel: HomeViewModel) {
        viewModel.arrMovie.asObservable().bind(to: self.carousel.rx.items(cellIdentifier: "MovieCarouselCell", cellType: MovieCarouselCell.self)) { (row, element, cell) in
            cell.binData(element)
            }
            .disposed(by: disposeBag)
        viewModel.completionFetchData = { [weak self] in
            guard let owner = self else { return }
            var offset = owner.carousel.contentOffset
            offset.x += 1
            owner.carousel.setContentOffset(offset, animated: true)
            owner.createTimerAutoScroll()
        }
    }
    
    fileprivate func setupCollectionViewWhenTap(with viewModel: HomeViewModel) {
        self.carousel.rx.itemSelected
            .subscribe(onNext : {[weak self] indexPath in
                print(indexPath)
                guard let owner = self else {return}
                owner.carousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupDidScroll(with viewModel: HomeViewModel) {
        _ = self.carousel.rx.didScroll
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext : {[weak self] in
                guard let owner = self else { return }
                
                if owner.previousCenterIndexPath == owner.carousel.currentCenterCellIndex ||
                    owner.movingToSearchPage == true {
                    return
                }
                guard let currentCenterIndex = owner.carousel.currentCenterCellIndex?.row, let viewModel = owner.viewModel else { return }
                let movie = viewModel.arrMovie.value[currentCenterIndex]
                owner.lblMovieTitle.text = movie.title
                if let genreIds = movie.genreIds {
                    owner.lblMovieGenre.text = genreIds.map{$0.name ?? ""}.joined(separator: ", ")
                }
                
                if let previousCenterIndexPath = owner.previousCenterIndexPath, let cell = owner.carousel.cellForItem(at: previousCenterIndexPath) as? MovieCarouselCell {
                    cell.hiddenBuyTicket(true)
                    owner.carousellScroll = false
                    owner.carouselTimer?.invalidate()
                }
                if let cell = owner.carousel.currentCenterCell as? MovieCarouselCell {
                    cell.hiddenBuyTicket(false)
                    owner.lblMovieTitle.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    owner.lblMovieGenre.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                        owner.lblMovieTitle.transform = .identity
                        owner.lblMovieGenre.transform = .identity
                    }, completion: nil)
                    owner.carousellScroll = true
                    owner.createTimerAutoScroll()
                    owner.previousCenterIndexPath = owner.carousel.currentCenterCellIndex
                    if let previoursIndexPath = owner.previousCenterIndexPath {
                        print("previours IndexPath: \(previoursIndexPath.row)")
                    }
                }
            })
    }
}

//MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
