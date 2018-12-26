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
    var viewModel = HomeViewModel(baseWebServices: BaseWebServices())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchButton()
        bindMovieList(with: viewModel)
        bindCenteredMovie(with: viewModel)
        setupCollectionViewWhenTap(with: viewModel)
        setupDidScroll(with: viewModel)
        viewModel.fetchMovieList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movingToSearchPage = false
        if let previoursIndexPath = self.previousCenterIndexPath {
            self.carousel.scrollToItem(at: previoursIndexPath, at: .centeredHorizontally, animated: false)
        }
        if viewModel.arrMovie.value.count > 0 {
            self.createTimerAutoScroll()
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

//MARK: - Private Func
extension HomeViewController {
    fileprivate func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        lctHeightHeader.constant = Application.sharedInstance.appTopOffset + 44
        lblMovieTitle.text = ""
        lblMovieGenre.text = ""
        carousel.register(UINib(nibName: "MovieCarouselCell", bundle: nil), forCellWithReuseIdentifier: "MovieCarouselCell")
    }
    
    fileprivate func setupSearchButton() {
        self.btnSearch.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let owner = self else { return }
            if let searchVC = owner.getViewController(storyboardName: "Main", className: "SearchViewController") as? SearchViewController {
                owner.movingToSearchPage = true
                owner.navigationController?.pushViewController(searchVC, animated: true)
            }
        }).disposed(by: self.disposeBag)
    }
    
    fileprivate func createTimerAutoScroll() {
        if let timer = self.carouselTimer {
            timer.invalidate()
        }
        self.carouselTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoscrollForBannerView), userInfo: nil, repeats: true)
    }
    
    @objc func autoscrollForBannerView() {
        guard let currentIndex = self.carousel.currentCenterCellIndex, viewModel.arrMovie.value.count > 0 else {
            return
        }
        if self.carousellScroll == false {
            self.carousel.scrollToItem(at: IndexPath(row: currentIndex.row, section: 0), at: .centeredHorizontally, animated: true)
        } else if self.viewModel.arrMovie.value.count > 0 && currentIndex.row < self.viewModel.arrMovie.value.count - 1 {
            let nextIndex  = currentIndex.row + 1
            self.carousel.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)

        }
        else {
            self.carousel.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    fileprivate func bindMovieList(with viewModel: HomeViewModel) {
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.arrMovie.asDriver().drive(self.carousel.rx.items(cellIdentifier: "MovieCarouselCell")) { _, movieViewModel, cell in
            movieViewModel.isHiddenBuyTicket.subscribe(onNext: { [weak self] (isHidden) in
                guard let owner = self else { return }
                if isHidden {
                    owner.carousellScroll = false
                    owner.carouselTimer?.invalidate()
                }
                else {
                    owner.lblMovieTitle.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    owner.lblMovieGenre.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                        owner.lblMovieTitle.transform = .identity
                        owner.lblMovieGenre.transform = .identity
                    }, completion: nil)
                    owner.carousellScroll = true
                    owner.createTimerAutoScroll()
                    owner.previousCenterIndexPath = owner.carousel.currentCenterCellIndex
                }
            }).disposed(by: self.disposeBag)
            if let movieCell = cell as? MovieCarouselCell {
                movieCell.binData(movieViewModel)
            }}
            .disposed(by: disposeBag)
        viewModel.completionFetchData = { [weak self] in
            guard let owner = self else { return }
            var offset = owner.carousel.contentOffset
            offset.x += 1
            owner.carousel.setContentOffset(offset, animated: true)
            owner.createTimerAutoScroll()
        }
    }
    
    fileprivate func bindCenteredMovie(with viewModel: HomeViewModel) {
        viewModel.centeredTitle
            .bind(to: self.lblMovieTitle.rx.text)
            .disposed(by: disposeBag)
        viewModel.centeredType.bind(to: self.lblMovieGenre.rx.text).disposed(by: disposeBag)
    }
    
    fileprivate func setupCollectionViewWhenTap(with viewModel: HomeViewModel) {
        self.carousel.rx.itemSelected
            .subscribe(onNext : {[weak self] indexPath in
                guard let owner = self else {return}
                owner.carousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setLoadingHud(visible: Bool) {
        if visible {
            Utils.showIndicator()
        }
        else {
            Utils.dismissIndicator()
        }
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
                guard let currentCenterIndex = owner.carousel.currentCenterCellIndex?.row else { return }
                owner.viewModel.centeredIndex = BehaviorSubject(value: currentCenterIndex)
                
                if let previousCenterIndexPath = owner.previousCenterIndexPath {
                    let vm = viewModel.arrMovie.value[previousCenterIndexPath.row]
                    vm.isHiddenBuyTicket.accept(true)
                }
                if let curentIndexPath = owner.carousel.currentCenterCellIndex {
                    let vm = viewModel.arrMovie.value[curentIndexPath.row]
                    vm.isHiddenBuyTicket.accept(false)
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
