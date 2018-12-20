//
//  Utils.swift
//  ProjectTemplate
//
//  Created by Giêng Thành on 6/11/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//


import UIKit
import CoreImage
import SVProgressHUD

var startTime = Date()
func TICK(){ startTime =  Date() }
func TOCK(_ function: String = #function, line: Int = #line){
    print("\(function) Time: \(startTime.timeIntervalSinceNow)\nLine:\(line)")
}

func delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

let kDateFormatWithPatternHHMM  =   "HH:mm"
let kDateFormatWithPatternHHMMSS  =   "HH:mm:ss"
let kDateFormatWithPatternDDMMYYYY  =   "dd/MM/yyyy"
let kDateFormatWithPatternMMDDYYYY  =   "MM/dd/yyyy"
let kDateFormatWithPatternGMT       =   "yyyy-MM-dd'T'HH:mm:ss'.'SSSSxxx"  //"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
let kDateFormatWithPatternGMTClassic = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
let kDateFormatWithPatternNormal = "yyyy-MM-dd HH:mm:ss"


class Utils: NSObject {
    class func showIndicator() {
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor(hexString: "#f2645a", alpha: 1)!)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    class func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    class func isValidEmail(_ stringCheck:String)->Bool {
        
        let strictFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        
        return  NSPredicate(format: "SELF MATCHES %@", strictFilterString).evaluate(with: stringCheck)
        
    }
    
    class func isEmpty(_ stringCheck:String)->Bool {
        if stringCheck.isEmpty || stringCheck.isBlank() {
            return true
        }
        let stringTemp =  stringCheck.replacingOccurrences(of: " ", with: "", options: [], range: nil)
        if stringTemp == "" {
            return true
        }
        
        return false
    }
    
    //example: Utils.formatPriceWithSymbol(123.88, symbol: "d")
    class func formatPriceWithSymbol(_ price:NSNumber, symbol:String) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.currencySymbol = ""
        currencyFormatter.positiveSuffix = symbol
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyDecimalSeparator = ","
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.locale =  Locale.current
        //        NSLocale(localeIdentifier: "es_ES")
        
        return currencyFormatter.string(from: price) ?? ""
    }
    
    
    class func formatPriceWithSymbolWith2Fraction(_ price:NSNumber, symbol:String) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.currencySymbol = ""
        currencyFormatter.positiveSuffix = symbol
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.currencyDecimalSeparator = ","
        currencyFormatter.allowsFloats = true
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.decimalSeparator = "."
        currencyFormatter.locale =  Locale.current
        //        NSLocale(localeIdentifier: "es_ES")
        
        return currencyFormatter.string(from: price)!
    }
    class func covertDateToStringFormatHHMMSS(_ date:Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        //        dateFormatter.locale = NSLocale(localeIdentifier: "vi_VN")
        dateFormatter.dateFormat = kDateFormatWithPatternHHMMSS
        
        return dateFormatter.string(from: date)
        
    }
    
    class func covertDateToStringFormatHHMM(_ date:Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormatWithPatternHHMM
        
        return dateFormatter.string(from: date)
        
    }
    
    class func covertDateToStringFormatDDMMYYYY(_ date:Date) -> String {
        return self.dateToStringFormatDDMMYYYY(date, useLocale: false)
    }
    
    class func dateToStringFormatDDMMYYYY(_ date:Date, useLocale:Bool)->String
    {
        return self.convertDateToString(date, format: kDateFormatWithPatternDDMMYYYY, locale: nil, useLocale: useLocale)
    }
    
    class func covertDateToStringFormatMMDDYYYY (_ date:Date) -> String {
        return self.dateToStringFormatMMDDYYYY(date, useLocale: false)
    }
    
    class func dateToStringFormatMMDDYYYY (_ date:Date, useLocale:Bool=false) -> String {
        return self.convertDateToString(date, format: kDateFormatWithPatternMMDDYYYY, locale: nil, useLocale: useLocale)
    }
    
    class func convertDateToString(_ date:Date, format:String)->String
    {
        return self.convertDateToString(date, format: format, locale: nil)
    }
    
    class func convertDateToString(_ date:Date, format:String, locale:Locale?, useLocale:Bool = false)->String
    {
        let dateFormatter = DateFormatter()
        if useLocale
        {
            if let tempLocale = locale
            {
                dateFormatter.locale = tempLocale
            }
            else
            {
                dateFormatter.locale = Locale(identifier: "vi_VN")
            }
        }
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    class func covertStringToDateNormal (_ string:String) -> Date? {
        return self.convertStringToDate(string, pattern: kDateFormatWithPatternNormal)
    }
    
    class func covertStringToDate (_ string:String) -> Date? {
        return self.convertStringToDate(string, pattern: kDateFormatWithPatternGMT)
    }
    class func covertStringToDateClassic (_ string:String) -> Date? {
        return self.convertStringToDate(string, pattern: kDateFormatWithPatternGMTClassic)
    }
    
    class func covertStringDDMMYYYYToDate (_ string:String) -> Date? {
        return self.convertStringToDate(string, pattern: kDateFormatWithPatternDDMMYYYY)
    }
    
    class func convertStringToDate(_ date:String, pattern:String)->Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        let  stringDate = dateFormatter.date(from: date)
        return   stringDate
    }

    class func attributeStringForTitle(_ title:String, value:String, titleFont:UIFont, valueFont:UIFont, titleColor:UIColor, valueColor:UIColor, separator:String?)->NSMutableAttributedString
    {
        return self.attributeStringForTexts(NSArray(arrayLiteral: title, value),
                                            fonts: [titleFont, valueFont],
                                            colors: [titleColor, valueColor],
                                            separator: separator)
    }
    
    class func attributeStringForTexts(_ texts:NSArray, fonts:[UIFont], colors:[UIColor], separator:String?)->NSMutableAttributedString
    {
        var tempSeparator   =   ""
        if let sepa =   separator
        {
            tempSeparator   =   sepa
        }
        
        let fullText:String =   texts.componentsJoined(by: tempSeparator)
        let result:NSMutableAttributedString    =   NSMutableAttributedString(string:fullText as String)
        
        var numChar =   0
        for i:Int in 0 ..< texts.count
        {
            let text:String =   texts[i] as! String
            let range   =   NSMakeRange(numChar, text.count)
            result.addAttribute(.font, value: fonts[i], range: range)
            result.addAttribute(.foregroundColor, value: colors[i], range: range)
            numChar +=  (text.count + tempSeparator.count)
        }
        
        return result;
    }
    
    class func drawCircle(_ view:UIView)
    {
        view.layer.cornerRadius  =   view.frame.height / 2.0
        view.layer.masksToBounds =   true
    }

    class func rotateCameraImageToProperOrientation(_ imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        
        let width = CGFloat(imgRef!.width);
        let height = CGFloat(imgRef!.height);
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef!.width), height: CGFloat(imgRef!.height))
        
        
        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: CGFloat.pi);
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * CGFloat(CGFloat.pi) / 2.0);
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * CGFloat(CGFloat.pi) / 2.0);
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat(CGFloat.pi) / 2.0);
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: CGFloat(CGFloat.pi) / 2.0);
            
            
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .right || orient == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio);
            context!.translateBy(x: -height, y: 0);
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio);
            context!.translateBy(x: 0, y: -height);
        }
        
        context!.concatenate(transform);
        UIGraphicsGetCurrentContext()!.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height));
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy!;
    }

    class func shortNameOfAgentName(_ agentName:String?)->String
    {
        var result:String  =   ""
        if let tempValue    =   agentName
        {
            var character:Int?
            let count = tempValue.length
            if count <= 3 {
                character = count
            }
            else {
                character = 3
            }
            result  =   (tempValue as NSString).substring(to: character!)
            result  =   result.uppercased()
        }
        
        return result
    }
    
    class func shortNameOfUser(_ firstName:String?, lastName:String?)->String
    {
        var result:String   =   ""
        if (firstName != nil && lastName != nil) && (firstName != "" && lastName != "")
        {
            let firstCharOfFirstName:String =   (firstName! as NSString).substring(to: 1).uppercased()
            let firstCharOfLastName:String  =   (lastName! as NSString).substring(to: 1).uppercased()
            result  =   "\(firstCharOfFirstName)\(firstCharOfLastName)"
        }
        return result
    }

    class func removeWhiteSpaceAtFirstString(_ fromString:String) -> String{
        let toArray = fromString.components(separatedBy: " ")
        var backToString = ""
        var space = ""
        for sub in toArray {
            backToString = backToString + space +  sub.replacingOccurrences(of: " ", with: "")
            if Utils.isEmpty(sub) {
                space = ""
            }else{
                space = " "
            }
            
        }
        
        return backToString
    }

    class func imageWithImage(_ image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func imageQR(_ string: String) -> UIImage? {
        let dat = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(dat, forKey: "inputMessage")
            let trans = CGAffineTransform(scaleX: 3, y: 3)
            if let result = filter.outputImage?.transformed(by: trans) {
                return UIImage(ciImage: result)
            }
        }
        return nil
    }
    
}

