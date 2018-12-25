//
//  MovieListCell.swift
//  ImaginatoPilot
//
//  Created by admin on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class MovieListCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingDescription: UILabel!
    @IBOutlet weak var ageCategoryContent: UIView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var buyTicketButton: UIButton!
    let disposeBag = DisposeBag()
    
    var viewModel: MovieViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            viewModel.displayTitle.asObserver().bind(to: self.titleLabel.rx.text).disposed(by: self.disposeBag)
//            viewModel.rate.asObserver().bind(to: self.ratingLabel.rx.text)
            self.posterImage.kf.setImage(with: URL(string: viewModel.posterPath))
            self.ratingLabel.text = "\(viewModel.rate)"
            viewModel.ageCategory.asObserver().bind(to: self.ratingDescription.rx.text).disposed(by: self.disposeBag)
            self.releaseDate.text = self.getDateFrom(timeStamp: viewModel.releaseDate)
            viewModel.descriptionValue.asObserver().bind(to: self.content.rx.text).disposed(by: self.disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyTicketButton.layer.cornerRadius = self.buyTicketButton.frame.height / 2
        self.buyTicketButton.clipsToBounds = true
        self.posterImage.layer.cornerRadius = 4
        self.ageCategoryContent.layer.cornerRadius = self.ageCategoryContent.frame.height / 2
        self.ageCategoryContent.layer.borderColor = UIColor.gray.cgColor
        self.ageCategoryContent.layer.borderWidth = 1
        self.posterImage.layer.cornerRadius = 8
        self.posterImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getDateFrom(timeStamp: Int?) -> String {
        guard timeStamp != nil else {
            return ""
        }
        let date = Date(timeIntervalSince1970: Double(timeStamp!))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
