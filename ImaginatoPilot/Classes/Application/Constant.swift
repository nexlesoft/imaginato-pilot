//
//  Constant.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//
import Foundation
import UIKit
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    //screen reslution
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA = UIScreen.main.scale >= 2.0
    
    static let IS_IPHONE_4_OR_LESS = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0)
    static let IS_IPHONE_5_OR_LESS = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH <= 568.0)
    static let IS_IPHONE_5 = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0)
    static let IS_IPHONE_6_OR_MORE = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH >= 667.0)
    static let IS_IPHONE_6 = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0)
    static let IS_IPHONE_6P = (ScreenSize.IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0)
    static let IsscaleWidth3x = ScreenSize.SCREEN_WIDTH >= 414
    static let ScaleWidth3x = ScreenSize.SCREEN_WIDTH / 414
}

let kUserFilename = "client.usr"
let kEncodeUsers_Client = "kEncodeUsers_Client"
let Device = UIDevice.current
let currentOsVersion = NSString(string: Device.systemVersion).doubleValue

let appdelegate = UIApplication.shared.delegate as! AppDelegate
let application = Application.sharedInstance

