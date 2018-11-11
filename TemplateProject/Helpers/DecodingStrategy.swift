//
//  DecodingStrategy.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/23/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation
import UIKit

class DecodingStrategy {
    
    static func decodeDate(date: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = .current
        let date = Date.init(timeIntervalSince1970: date / 1000)
        return dateFormatter.string(from: date)
    }
    
    static func decodeDateWithTime(date: Double) -> (String,String) {
        let date1 = DateFormatter()
        date1.dateFormat = "MM dd, yyyy"
        date1.locale = .current
        
        let hour = DateFormatter()
        hour.dateFormat = "HH:mm"
        hour.locale = .current
        let date = Date.init(timeIntervalSince1970: date / 1000)
        return (date1.string(from: date), hour.string(from: date))
    }
    
    static func decodeDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = .current
        
        return dateFormatter.date(from: date)
    }
    
    /// Decode a date (Strubg) from the firebase
    ///
    /// - Parameter date: the date (String)
    /// - Returns: The string representation of the date (MM YYYY)
    static func decodeSimpleDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = .current
        
        guard let date = dateFormatter.date(from: date) else {
            return "unknown date"
        }
        
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    
    /// Decode an image url (String) from the firebase
    ///
    /// - Parameter imageURL: The url link of the image
    /// - Returns: UIImage
    static func decodeImage(imageURL: String) -> UIImage? {
        let url = URL(string: imageURL)
        guard let data = try? Data(contentsOf: url!) else {
            print("Could not load cell image")
            return nil
        }
        
        return UIImage(data: data)
    }
    
    /// Decode an image url (String) from the firebase with SDWebImage pod
    ///
    /// - Parameter imageURL: The url link of the image
    /// - Returns: UIImage
//    static func decodeImageWithSD(imageURL: String?) -> UIImage {
//        guard let imageURL = imageURL else { return #imageLiteral(resourceName: "icon_username_inactive.png") }
//        do {
//            guard let url = URL(string: imageURL) else { return #imageLiteral(resourceName: "icon_username_inactive.png")}
//            let imageData = try Data(contentsOf: url as URL)
//            return UIImage.sd_image(with: imageData)!
//        } catch {
//            print("Unable to load data: \(error)")
//            return #imageLiteral(resourceName: "icon_username_inactive.png")
//        }
//
//    }
    
    
    // can be replace by SwiftDate
    static func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}
