//
//  DateEx.swift
//  TemplateProject
//
//  Created by Dung Do on 4/19/18.
//  Copyright © 2018 HD. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DateStatus: Int {
    case ACCEPTED = 0
    case PENDING
    case EXPIRES
}

extension Date {
    
    static func checkStatus(startDate: Date, endDate: Date, complete:((_ status: DateStatus?)->())?) {
        guard let complete = complete else {
            return
        }
        
        self.getCurrentDate { (currentDate) in
            if (self.daysDiffrence(from: startDate, to: currentDate) < 0) {
                complete(.PENDING)
            } else if (self.daysDiffrence(from: endDate, to: currentDate) > 0) {
                complete(.EXPIRES)
            } else {
                complete(.ACCEPTED)
            }
        }
    }
    
    static func getCurrentDate(complete:((_ date: Date)->())?) {
        guard let complete = complete else {
            return
        }
        
        let urlTime = "http://worldtimeapi.org/api/ip"
        K.net.get(url: urlTime) { (data, error) in
            if let data = data {
                var strCurrentDate: String = data["utc_datetime"].stringValue
                strCurrentDate = String(strCurrentDate[...strCurrentDate.index(strCurrentDate.startIndex, offsetBy: 18)])
                let currentDate: Date? = strCurrentDate.toDate(format: K.defaultDateFormat)
                
                if let currentDate = currentDate {
                    Log.d(currentDate)
                    complete(currentDate)
                } else {
                    Log.e(Date())
                    complete(Date())
                }
            } else {
                Log.e(error.debugDescription)
                complete(Date())
            }
        }
    }
    
    static func daysDiffrence(from startDate: Date, to endDate: Date) -> Int {
        let calendat: Calendar = Calendar(identifier: .gregorian)
        let startDay: Int = calendat.ordinality(of: .day, in: .era, for: startDate)!
        let endDay: Int = calendat.ordinality(of: .day, in: .era, for: endDate)!
        
        // -1: yesterday, 0: today, 1: tomorrow, ...
        return endDay - startDay
    }
    
    func relativeString() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfMonth, .month], from: self, to: now)

        let month = components.month ?? 0
        let weeks = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        if month > 0 {
            return String(format: "%d months ago", month)
        } else if weeks > 0 {
            return String(format: "%d weeks ago", weeks)
        } else if day > 0 {
            return String(format: "%d days ago", day)
        } else if hour > 0 {
            return String(format: "%d hour ago", hour)
        } else if minute > 0 {
            return String(format: "%d minute ago", minute)
        } else {
            return String(format: "Now", minute)
        }
    }
    
    static func timeLeft(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        
        if hours == 0 {
            return String(format:"%02i:%02i", minutes, seconds)
        }
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func toString(format: String = K.defaultDateFormat, isUTC: Bool = true) -> String? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = isUTC ? TimeZone(abbreviation: "UTC") : nil
        let date = dateFormatter.string(from: self)
        
        return date
    }
    
}
