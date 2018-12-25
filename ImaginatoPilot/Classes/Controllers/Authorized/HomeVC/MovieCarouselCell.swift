//
//  MovieCarouselCell.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
import Kingfisher
import ScalingCarousel

class MovieCarouselCell: ScalingCarouselCell {
    @IBOutlet fileprivate weak var imvPoster: UIImageView!
    @IBOutlet fileprivate weak var lblPreSale: UILabel!
    @IBOutlet fileprivate weak var btnBuyTicket: UIButton!
    @IBOutlet fileprivate weak var lctHeightBuyTicket: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 20
        self.mainView.clipsToBounds = true
        self.lblPreSale.layer.masksToBounds = true
        self.lblPreSale.layer.cornerRadius = 5.0
        self.lblPreSale.isHidden = true
        self.imvPoster.layer.masksToBounds = true
        self.imvPoster.layer.cornerRadius = 20
        self.lctHeightBuyTicket.constant = 0
        self.btnBuyTicket.isHidden = true
    }

    func binData(_ movie: MovieDTO) {
        self.imvPoster.contentMode = .center
        if let posterPath = movie.posterPath {
            self.imvPoster.kf.setImage(with: URL(string: posterPath), placeholder: UIImage(named: "ic_placeholder"), options: [.backgroundDecode], progressBlock: nil) { (image, error, type, url) in
                self.imvPoster.contentMode = .scaleToFill
                self.imvPoster.image = image
            }
        }
        else {
            self.imvPoster.image = UIImage(named: "ic_placeholder")
        }
        if movie.presaleFlag == 1 {
            self.lblPreSale.isHidden = false
        }
        else {
            self.lblPreSale.isHidden = true
        }
    }
    
    func hiddenBuyTicket(_ isHidden: Bool) {
        if isHidden == true {
            self.lctHeightBuyTicket.constant = 0
            self.btnBuyTicket.isHidden = isHidden
        }
        else {
            self.lctHeightBuyTicket.constant = 40
            self.btnBuyTicket.isHidden = isHidden
            btnBuyTicket.transform = CGAffineTransform(scaleX: 0.3, y: 1.5)
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.btnBuyTicket.transform = .identity
            }, completion: nil)
        }
    }
}
