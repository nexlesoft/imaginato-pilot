//
//  MovieListCell.swift
//  ImaginatoPilot
//
//  Created by admin on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingDescription: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var buyTicketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyTicketButton.layer.cornerRadius = self.buyTicketButton.frame.height / 2
        self.buyTicketButton.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
