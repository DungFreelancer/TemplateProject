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
        
        let urlTime = "http://worldclockapi.com/api/json/utc/now"
        NetworkHelper.shared.get(url: urlTime) { (json, error) in
            if let json = json {
                let strCurrentDate: String = json["currentDateTime"].string!
                let currentDate: Date? = strCurrentDate.toDate(format: "yyyy-MM-dd'T'HH:mmZ");
                
                if let currentDate = currentDate {
                    complete(currentDate)
                } else {
                    complete(Date())
                }
            } else {
                Log.error(error.debugDescription)
                complete(Date())
            }
        }
    }
    
    static func daysDiffrence(from startDate: Date, to endDate: Date) -> Int {
        let calendat: Calendar = Calendar(identifier: .gregorian)
        let startDay: Int = calendat.ordinality(of: .day, in: .era, for: startDate)!
        let endDay: Int = calendat.ordinality(of: .day, in: .era, for: endDate)!
        
        return endDay - startDay
    }
    
    func toString(format: String?) -> String? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd:HH:mm:ss"
        let date = dateFormatter.string(from: self)
        return date
    }
    
}
