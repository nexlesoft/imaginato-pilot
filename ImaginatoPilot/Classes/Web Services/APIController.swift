//
//  APIController.swift
//  ImaginatoPilot
//
//  Created by Trai on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

typealias ErrorResponseBlock = (_ error: String?) -> Void
typealias ResponseBlock = (_ errorResponse: String?, _ json: JSON?) -> Void

enum HeaderType{
    case none
    case token
}

final class DataInfo{
    
    var withName: String!
    var fileName: String!
    var mimeType: String!
    
    init(withName: String, fileName: String, mimeType: String){
        self.withName = withName
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
}

struct APIController{
    
    //MARK: - DEFAULT REQUEST
    static func request(url: String, params: Parameters? = nil, result: @escaping ResponseBlock) {
        // Check internet connection
        if !NetworkReachabilityManager()!.isReachable {
            result("No Internet Connection",nil)
        }
        Utils.showIndicator()
        Alamofire.request(url, method: .get, parameters: params, headers: [:]).validate().responseJSON { (responseObject) -> Void in
            Utils.dismissIndicator()
            if responseObject.response?.statusCode == 403 {
                
            }
            switch responseObject.result{
            case .success(let data):
                let response = JSON(data)
                result(nil, response)
            case .failure(let error):
                if let data = responseObject.data {
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    let response = JSON(parseJSON: json)
                    guard let message = response[APIKeyword.Response.errors].string else {
                        result(error.localizedDescription, nil)
                        return
                    }
                    result(message,nil)
                }
            }
        }
    }
    
    
    static func request(manager: APIManager, params: Parameters? = nil, result: @escaping ResponseBlock) {
        // Check internet connection
        if !NetworkReachabilityManager()!.isReachable {
            result("No Internet Connection",nil)
        }
        Utils.showIndicator()
        Alamofire.request(manager.url, method: manager.method, parameters: params, headers: manager.header).validate().responseJSON { (responseObject) -> Void in
            Utils.dismissIndicator()
            switch responseObject.result{
            case .success(let data):
                let response = JSON(data)
                result(nil, response)
            case .failure(let error):
                if let data = responseObject.data {
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    let response = JSON(parseJSON: json)
                    guard let message = response[APIKeyword.Response.errors].string else {
                        result(error.localizedDescription, nil)
                        return
                    }
                    result(message,nil)
                }
            }
        }
    }
}
