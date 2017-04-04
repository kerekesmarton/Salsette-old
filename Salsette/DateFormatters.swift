//
//  Utils.swift
//  CoreUser
//
//  Created by Kerekes Jozsef-Marton on 2016. 11. 04..
//  Copyright © 2016. mkerekes. All rights reserved.
//

import Foundation

class DateFormatters {
    
    private init() {}
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static var dateTimeFormatter: DateFormatter = {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return dateTimeFormatter
    }()
    
    static var relativeDateFormatter: DateFormatter = {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.dateStyle = .short
        relativeDateFormatter.timeStyle = .short
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }()
    
    static var timeFormatter: DateFormatter  = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .long
        
        return timeFormatter
    } ()
}
