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
    var titleLable = BehaviorSubject<String>(value: "")
    init(str:String) {
        self.titleLable = BehaviorSubject<String>(value: str)
    }
}
