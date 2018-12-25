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
    
    var viewModel: HistoryViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            viewModel.titleLable.asObservable().bind(to: self.titleLabel.rx.text).disposed(by: self.disposeBag)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

