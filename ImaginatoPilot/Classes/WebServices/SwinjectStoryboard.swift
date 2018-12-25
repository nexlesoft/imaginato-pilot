//
//  SwinjectStoryboard.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/25/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    class func setup() {
        defaultContainer.register(BaseWebServices.self, factory: { _ in
            BaseWebServices()
        }).inObjectScope(.container)

        let baseWebServices = defaultContainer.resolve(BaseWebServices.self)

        if let baseWebServices = baseWebServices {
            defaultContainer.register(HomeViewModel.self, factory: { _ in
                HomeViewModel(baseWebServices: baseWebServices)
            })
        }
    }

    static func getContainer() -> Container {
        return defaultContainer
    }
    
}
