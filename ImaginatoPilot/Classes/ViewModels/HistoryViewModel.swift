//
//  HistoryViewModel.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/25/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryViewModel{
    var titleLable = Variable<String>("")
    init(str:String) {
        self.titleLable = Variable<String>(str)
    }
}
