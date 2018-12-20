//
//  MovieCarouselView.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/20/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCarouselView: UIView {

    @IBOutlet fileprivate weak var imvPoster: UIImageView!
    @IBOutlet fileprivate weak var lblPreSale: UILabel!
    @IBOutlet fileprivate weak var btnBuyTicket: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imvPoster.layer.masksToBounds = true
        self.imvPoster.layer.cornerRadius = 10.0
        
        self.lblPreSale.layer.masksToBounds = true
        self.lblPreSale.layer.cornerRadius = 5.0
    }
    
    func binData(_ movie: MovieDTO) {
        self.imvPoster.contentMode = .center
        if let posterPath = movie.posterPath {
            self.imvPoster.sd_setImage(with: URL(string: posterPath), placeholderImage: UIImage(named: "ic_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil) { (image, error, type, url) in
                self.imvPoster.contentMode = .scaleToFill
                self.imvPoster.image = image
            }
        }
        else {
            self.imvPoster.image = UIImage(named: "ic_placeholder")
        }
    }
}