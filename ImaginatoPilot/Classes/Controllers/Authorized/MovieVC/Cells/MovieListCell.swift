//
//  MovieListCell.swift
//  ImaginatoPilot
//
//  Created by admin on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingDescription: UILabel!
    @IBOutlet weak var ageCategoryContent: UIView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var buyTicketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyTicketButton.layer.cornerRadius = self.buyTicketButton.frame.height / 2
        self.buyTicketButton.clipsToBounds = true
        self.posterImage.layer.cornerRadius = 4
        self.ageCategoryContent.layer.cornerRadius = self.ageCategoryContent.frame.height / 2
        self.ageCategoryContent.layer.borderColor = UIColor.gray.cgColor
        self.ageCategoryContent.layer.borderWidth = 1
    }
    
    func loadFromMovie(movie: MovieDTO) {
        self.titleLabel.text = movie.title
        self.posterImage.kf.setImage(with: URL(string: movie.posterPath!))
        self.posterImage.layer.cornerRadius = 8
        self.posterImage.layer.masksToBounds = true
        self.ratingLabel.text = "\(movie.rate!)"
        self.ratingDescription.text = movie.ageCategory
        self.releaseDate.text = self.getDateFrom(timeStamp: movie.releaseDate)
        self.content.text = movie.descriptionValue
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
