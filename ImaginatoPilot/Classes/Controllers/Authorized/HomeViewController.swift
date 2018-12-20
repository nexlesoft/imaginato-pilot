//
//  HomeViewController.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

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
        lctHeightHeader.constant = Application.sharedInstance.appTopOffset + 44
        carousel.type = .rotary
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
            return movieView
        }
        else {
            let movieView = MovieCarouselView.loadNib()
            movieView.binData(arrMovie[index])
            return movieView
        }
    }
}
