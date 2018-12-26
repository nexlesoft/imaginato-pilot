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
    
    fileprivate var carouselTimer : Timer?
    
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
        viewModel.movingToSearchPage.accept(false)
        if let previoursIndexPath = self.viewModel.previousCenterIndexPath {
            do {
                let index = try previoursIndexPath.value()
                self.carousel.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            }
            catch {
                print("Invalid index")
            }
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
        carousel.register(UINib(nibName: "MovieCarouselCell", bundle: nil), forCellWithReuseIdentifier: "MovieCarouselCell")
    }
    
    fileprivate func setupSearchButton() {
        self.btnSearch.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let owner = self else { return }
            if let searchVC = owner.getViewController(storyboardName: "Main", className: "SearchViewController") as? SearchViewController {
                owner.viewModel.movingToSearchPage.accept(true)
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
        if self.viewModel.carousellScroll.value == false {
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
                    viewModel.carousellScroll.accept(false)
                    owner.carouselTimer?.invalidate()
                }
                else {
                    owner.lblMovieTitle.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    owner.lblMovieGenre.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                        owner.lblMovieTitle.transform = .identity
                        owner.lblMovieGenre.transform = .identity
                    }, completion: nil)
                    viewModel.carousellScroll.accept(true)
                    owner.createTimerAutoScroll()
                    if let currentCenterCellIndex = owner.carousel.currentCenterCellIndex {
                        viewModel.previousCenterIndexPath = BehaviorSubject<IndexPath>(value: currentCenterCellIndex)
                    }
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
        viewModel
            .onShowError
            .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
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
                if let previousCenterIndexPath = owner.viewModel.previousCenterIndexPath {
                    do {
                        if try previousCenterIndexPath.value() == owner.carousel.currentCenterCellIndex ||
                            owner.viewModel.movingToSearchPage.value == true {
                            return
                        }
                    }
                    catch {
                        print("Invalid")
                    }
                }
                guard let currentCenterIndex = owner.carousel.currentCenterCellIndex?.row else { return }
                owner.viewModel.centeredIndex = BehaviorSubject(value: currentCenterIndex)
                if let previousCenterIndexPath = owner.viewModel.previousCenterIndexPath {
                    do {
                        let index = try previousCenterIndexPath.value()
                        let vm = viewModel.arrMovie.value[index.row]
                        vm.isHiddenBuyTicket.accept(true)
                    }
                    catch {
                        print("Invalid index")
                    }
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
