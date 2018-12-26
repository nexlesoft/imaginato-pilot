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
        self.selectSection(index: 0)
        
        setUpEventTouchBackButton()
        setUpEventTouchShowingButton()
        setUpEventToushComingSoonButton()
        
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
    func selectSection(index: Int) {
        if index == 0 {
            self.showingButton.setTitleColor(UIColor.black, for: .normal)
            self.comingSoonButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.showingIndicatorLine.isHidden = false
            self.comingSoonIndicatorLine.isHidden = true
        } else if index == 1 {
            self.showingButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.comingSoonButton.setTitleColor(UIColor.black, for: .normal)
            self.showingIndicatorLine.isHidden = true
            self.comingSoonIndicatorLine.isHidden = false
        } else {
            print("Section not available")
        }
    }
    
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
            .subscribe() { event in
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setUpEventTouchShowingButton() {
        self.showingButton.rx.tap
            .subscribe() { event in
                if self.currentIndex != 0 {
                    self.selectSection(index: 0)
                    self.currentIndex = 0
                    guard let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 0) else { return }
                    startingViewController.viewModel = self.viewModel
                    let viewControllers = [startingViewController]
                    self.pageViewController?.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
    }
    
    private func setUpEventToushComingSoonButton() {
        self.comingSoonButton.rx.tap
            .subscribe() { event in
                if self.currentIndex != 1 {
                    self.selectSection(index: 1)
                    self.currentIndex = 1
                    guard let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 1) else { return }
                    startingViewController.viewModel = self.viewModel
                    let viewControllers = [startingViewController]
                    self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
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
        selectSection(index: index)
        viewController.viewModel = self.viewModel
        currentIndex = index
    }
}
