//
//  StringEx.swift
//  TemplateProject
//
//  Created by Tran Gia Huy on 10/1/17.
//  Copyright © 2017 HD. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(format: String?) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd:HH:mm:ss"
        let date = dateFormatter.date(from: self)
        return date
    }
    
}
