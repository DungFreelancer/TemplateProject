//
//  StringEx.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String {
        if let path = Bundle.main.path(forResource: K.currentLanguage.rawValue, ofType: "lproj") {
            return Bundle(path: path)!.localizedString(forKey: self, value: nil, table: nil)
        } else {
            Log.e("Can't found \(K.currentLanguage.rawValue) language!!!")
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toDate(format: String = K.defaultDateFormat) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toMoney() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        //currencyFormatter.locale = Locale.current
        currencyFormatter.locale = Locale(identifier: "fr_FR")
        
        var priceString = currencyFormatter.string(from: NSNumber(value: Double(self) ?? 0))!
        priceString.removeLast()
        priceString.removeLast()
        return priceString
    }
    
    func uppercasedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}
