//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

extension Date {
    func noMinutes() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func noHours() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(0, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func setting(hour toHour: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(toHour, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
}
