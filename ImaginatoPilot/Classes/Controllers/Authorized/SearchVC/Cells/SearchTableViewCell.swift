//
//  SearchTableViewCell.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//
import UIKit
import RxSwift
class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

