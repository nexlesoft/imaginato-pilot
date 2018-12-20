//
//  NSString+Utilities.swift

import UIKit

extension String
{
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSS"
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString!
    }
    
    func toDateTimeWithUIFormat() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString!
    }
    
    func attributedSizeWithFont(_ font:UIFont, maxWidth:CGFloat, lineSpacing:CGFloat)->CGSize
    {
        let style:NSMutableParagraphStyle   =   NSMutableParagraphStyle()
        style.lineBreakMode =   NSLineBreakMode.byWordWrapping
        if lineSpacing > -1
        {
            style.lineSpacing   =   lineSpacing
        }
        
        let attributedText:NSAttributedString   =   NSAttributedString(string: self, attributes: [NSAttributedStringKey.font:font,
            NSAttributedStringKey.foregroundColor:UIColor.black,
            NSAttributedStringKey.paragraphStyle:style])
        
        let textRect:CGRect =   attributedText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin ,
            context: nil)
        
        return textRect.size
    }
    
    func sizeWithFont(_ font:UIFont, maxWidth:CGFloat)->Float
    {
//        let labelFontTemp = UILabel()
//        labelFontTemp.font = font
//        labelFontTemp.text = self
//        labelFontTemp.numberOfLines = 0
//        // -20 for padding of label description
//        return Float(labelFontTemp.sizeThatFits(CGSizeMake(maxWidth, 99999)).height + 5)
        return Float(self.calculateSizeWithFont(font, maxWidth: maxWidth).height + 5)
    }
    
    func calculateSizeWithFont(_ font:UIFont, maxWidth:CGFloat)->CGSize
    {
        let labelFontTemp = UILabel()
        labelFontTemp.font = font
        labelFontTemp.text = self
        labelFontTemp.numberOfLines = 0
        // -20 for padding of label description
        return labelFontTemp.sizeThatFits(CGSize(width: maxWidth, height: 99999))
    }
    
    var capitalizedFirstChar:String {
        var result = self.lowercased()
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    var removeSpacing:String{
        let result  =   self
        return result.replacingOccurrences(of: " ",
                with: "",
                options: NSString.CompareOptions.literal,
                range: nil)
    }
    
    func isBlank()->Bool
    {
        var result:Bool =   true
        let trimString:String  =   self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimString.length > 0
        {
            result  =   false
        }
        return result
    }
    
    func isEmail()->Bool
    {
        let reg:String  =   "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        return self.predicateWithFormat(reg)
    }
    
    func isDigit()->Bool
    {
        let reg:String  =   "[0-9]+"
        return self.predicateWithFormat(reg)
    }
    
    func isIPAddress()->Bool
    {
        let reg:String  =   "^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$"
        
        return self.predicateWithFormat(reg)
    }
    
    func isHostName()->Bool
    {
        let reg:String  =   "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return self.predicateWithFormat(reg)
    }
    
    
    func predicateWithFormat(_ format:String)->Bool
    {
        let predicate:NSPredicate   =   NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    
//    func md5() -> String {
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//        if let data = self.data(using: String.Encoding.utf8) {
//            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
//        }
//
//        var digestHex = ""
//        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//            digestHex += String(format: "%02x", digest[index])
//        }
//
//        return digestHex
//    }
}

extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    
   
}

