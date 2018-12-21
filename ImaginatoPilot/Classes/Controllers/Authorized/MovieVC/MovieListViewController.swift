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
    
    var keyword = ""
    
    @IBOutlet weak var showingButton: UIButton!
    @IBOutlet weak var showingIndicatorLine: UIView!
    @IBOutlet weak var comingSoonButton: UIButton!
    @IBOutlet weak var comingSoonIndicatorLine: UIView!
    @IBOutlet weak var pageView: UIView!
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var viewModel = MovieListViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectSection(index: 0)
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: 320, height: pageView.frame.size.height)
        
        self.addChildViewController(pageViewController!)
        self.pageView.addSubview((pageViewController?.view)!)
//        if let scrollView = self.pageViewController?.view.subviews.filter({$0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
//            scrollView.isScrollEnabled = false
//        }
        pageViewController?.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func touchBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchShowing(_ sender: Any) {
        if currentIndex != 0 {
            selectSection(index: 0)
            currentIndex = 0
            let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 0)!
            startingViewController.viewModel = self.viewModel
            let viewControllers = [startingViewController]
            self.pageViewController?.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    @IBAction func touchComingSoon(_ sender: Any) {
        if currentIndex != 1 {
            selectSection(index: 1)
            currentIndex = 1
            let startingViewController: MovieListContentViewController = self.viewControllerAtIndex(index: 1)!
            startingViewController.viewModel = self.viewModel
            let viewControllers = [startingViewController]
            self.pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        }
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieListContentViewController") as! MovieListContentViewController
        vc.pageIndex = index
        vc.keyword = self.keyword
        return vc
    }
}

// MARK: Page View Controller Data Source
extension MovieListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MovieListContentViewController).pageIndex
        index += 1
        if index == 2 {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MovieListContentViewController).pageIndex
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
        currentIndex = index
//        viewController.tableView.delegate = nil
//        viewController.tableView.dataSource = nil
    }
}
