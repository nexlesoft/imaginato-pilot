//
//  MovieListViewController.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import RxSwift

class MovieListViewController: BaseViewController {
    
    @IBOutlet weak var showingButton: UIButton!
    @IBOutlet weak var showingIndicatorLine: UIView!
    @IBOutlet weak var comingSoonButton: UIButton!
    @IBOutlet weak var comingSoonIndicatorLine: UIView!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var keyword = ""
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    let disposeBag = DisposeBag()
    var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpEventTouchBackButton()
        setUpEventTouchShowingButton()
        setUpEventToushComingSoonButton()
        bindViewModel()
        self.viewModel.setIndex(0)
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 0)!
        startingViewController.viewModel = self.viewModel
        let viewControllers = [startingViewController]
        self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: 320, height: pageView.frame.size.height)
        
        self.addChildViewController(pageViewController ?? UIPageViewController())
        self.pageView.addSubview(pageViewController?.view ?? UIView())
        pageViewController?.didMove(toParentViewController: self)
        
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel.sectionIndex.subscribe(onNext: { [weak self](index) in
            //index changed
            if index == 0 {
                self?.viewModel.showingButtonColor.onNext(.black)
                self?.viewModel.upcomingButtonColor.onNext(.lightGray)
                self?.viewModel.showingLineIsHidden.onNext(false)
                self?.viewModel.upcomingLineIsHidden.onNext(true)
            } else if index == 1 {
                self?.viewModel.showingButtonColor.onNext(.lightGray)
                self?.viewModel.upcomingButtonColor.onNext(.black)
                self?.viewModel.showingLineIsHidden.onNext(true)
                self?.viewModel.upcomingLineIsHidden.onNext(false)
            } else {
                print("Section not available")
            }
        }).disposed(by: disposeBag)
        
        viewModel.showingButtonColor.subscribe(onNext: { [weak self](color) in
            self?.showingButton.setTitleColor(color, for: .normal)
        }).disposed(by: disposeBag)
        viewModel.upcomingButtonColor.subscribe(onNext: { [weak self](color) in
            self?.comingSoonButton.setTitleColor(color, for: .normal)
        }).disposed(by: disposeBag)
        viewModel.showingLineIsHidden.subscribe(onNext: { [weak self](isHidden) in
            self?.showingIndicatorLine.isHidden = isHidden
        }).disposed(by: disposeBag)
        viewModel.upcomingLineIsHidden.subscribe(onNext: { [weak self](isHidden) in
            self?.comingSoonIndicatorLine.isHidden = isHidden
        }).disposed(by: disposeBag)
    }
    
    private func setLoadingHud(visible: Bool) {
        if visible {
            Utils.showIndicator()
        }
        else {
            Utils.dismissIndicator()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchMovieList(keyword: self.keyword)
        if self.navigationController?.isNavigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    deinit {
        print("Deinit MovieListViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: User Interaction
extension MovieListViewController {
    
    func viewControllerAtIndex(index: Int) -> MovieListContentViewController? {
        if index < 0 || index > 1 {
            return nil
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieListContentViewController") as? MovieListContentViewController
        
        vc?.pageIndex = index
        vc?.keyword = self.keyword
        return vc
    }
    
    private func setUpEventTouchBackButton() {
        self.backButton.rx.tap
            .subscribe() { [weak self] event in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setUpEventTouchShowingButton() {
        self.showingButton.rx.tap
            .subscribe() { [weak self] event in
                if self?.currentIndex != 0 {
                    self?.viewModel.setIndex(0)
                    self?.currentIndex = 0
                    guard let startingViewController: MovieListContentViewController = self?.viewControllerAtIndex(index: 0) else { return }
                    startingViewController.viewModel = self?.viewModel
                    let viewControllers = [startingViewController]
                    self?.pageViewController?.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setUpEventToushComingSoonButton() {
        self.comingSoonButton.rx.tap
            .subscribe() { [weak self] event in
                if self?.currentIndex != 1 {
                    self?.viewModel.setIndex(1)
                    self?.currentIndex = 1
                    guard let startingViewController: MovieListContentViewController = self?.viewControllerAtIndex(index: 1) else { return }
                    startingViewController.viewModel = self?.viewModel
                    let viewControllers = [startingViewController]
                    self?.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: Page View Controller Data Source
extension MovieListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let movieViewController = viewController as? MovieListContentViewController else { return nil }
        var index = movieViewController.pageIndex
        index += 1
        if index == 2 {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let movieViewController = viewController as? MovieListContentViewController else { return nil }
        var index = movieViewController.pageIndex
        index -= 1
        if index < 0 {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = (pendingViewControllers.first as? MovieListContentViewController) else { return }
        let index = viewController.pageIndex
        self.viewModel.setIndex(index)
        viewController.viewModel = self.viewModel
        currentIndex = index
    }
}
