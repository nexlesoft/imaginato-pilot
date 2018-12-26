//
//  AlertDTO.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/26/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import UIKit
struct AlertAction {
    let buttonTitle: String
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
