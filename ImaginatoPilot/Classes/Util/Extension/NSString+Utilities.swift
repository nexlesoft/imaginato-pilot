//
//  NSString+Utilities.swift

import UIKit

extension String
{
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
}
