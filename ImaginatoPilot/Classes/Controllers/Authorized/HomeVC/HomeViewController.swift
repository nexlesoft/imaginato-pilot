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
class HomeViewController: BaseViewController {
    
    @IBOutlet fileprivate weak var carousel: ScalingCarouselView!
    @IBOutlet fileprivate weak var lctHeightHeader: NSLayoutConstraint!
    @IBOutlet fileprivate weak var btnSearch: UIButton!
    @IBOutlet fileprivate weak var lblMovieTitle: UILabel!
    @IBOutlet fileprivate weak var lblMovieGenre: UILabel!
    
    fileprivate var arrMovie: [MovieDTO] = []
    fileprivate var previousCenterIndexPath: IndexPath?
    fileprivate var carousellScroll : Bool = true
    fileprivate var carouselTimer : Timer?
    
    let disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.Data.drive(onNext: { [weak self](movies) in
            guard let owner = self else { return }
            owner.arrMovie = movies
            owner.carousel.reloadData()
            var offset = owner.carousel.contentOffset
            offset.x += 1
            owner.carousel.setContentOffset(offset, animated: true)
            owner.createTimerAutoScroll()
        }, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    private func createTimerAutoScroll() {
        if let timer = self.carouselTimer {
            timer.invalidate()
        }
        self.carouselTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoscrollForBannerView), userInfo: nil, repeats: true)
    }
    
    @objc func autoscrollForBannerView() {
        guard let currentIndex = self.carousel.currentCenterCellIndex, self.arrMovie.count > 0 else {
            return
        }
        if self.carousellScroll == false {
            self.carousel.scrollToItem(at: IndexPath(row: currentIndex.row, section: 0), at: .centeredHorizontally, animated: true)
        } else if self.arrMovie.count > 0 && currentIndex.row < self.arrMovie.count - 1 {
            let nextIndex  = currentIndex.row + 1
            self.carousel.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        else {
            self.carousel.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

//MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCarouselCell", for: indexPath)
        
        if let scalingCell = cell as? MovieCarouselCell {
            scalingCell.binData(arrMovie[indexPath.row])
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        carousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.previousCenterIndexPath == carousel.currentCenterCellIndex {
            return
        }
        guard let currentCenterIndex = carousel.currentCenterCellIndex?.row else { return }
        let movie = arrMovie[currentCenterIndex]
        self.lblMovieTitle.text = movie.title
        if let genreIds = movie.genreIds {
            self.lblMovieGenre.text = genreIds.map{$0.name ?? ""}.joined(separator: ", ")
        }
        
        if let previousCenterIndexPath = self.previousCenterIndexPath, let cell = carousel.cellForItem(at: previousCenterIndexPath) as? MovieCarouselCell {
            cell.hiddenBuyTicket(true)
            self.carousellScroll = false
            self.carouselTimer?.invalidate()
        }
        if let cell = carousel.currentCenterCell as? MovieCarouselCell {
            cell.hiddenBuyTicket(false)
            self.lblMovieTitle.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
            self.lblMovieGenre.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.lblMovieTitle.transform = .identity
                self.lblMovieGenre.transform = .identity
            }, completion: nil)
            self.carousellScroll = true
            self.createTimerAutoScroll()
        }
        self.previousCenterIndexPath = carousel.currentCenterCellIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
