//
//  APIManager.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import Alamofire

enum APIManager {
    case home
    case search(String, Int)
}

extension APIManager {
    
    var baseURL: String { return "https://easy-mock.com/mock/5c19c6ff64b4573fc81a61f3/movieapp/" }
    
    //MARK: - URL
    var url: String {
        var path = ""
        switch self {
        case .home:
            path = "home"
        case .search(let textSearch, let offset):
            path = "search?keyword=\(textSearch)&offset=\(offset)"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        return .get
    }
    
    //MARK: - HEADER
    var header: [String : String]?{
        return ["Content-Type": "application/json"]
    }
}
