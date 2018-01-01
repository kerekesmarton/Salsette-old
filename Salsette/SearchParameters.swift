//  Copyright © 2018 Marton Kerekes. All rights reserved.

import Foundation

enum DataType{
    case name(String?)
    case location(String?)
    case startDate(Date?)
    case endDate(Date?)
    case type(Dance?)
}

struct SearchParameters {
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var type: Dance?
    
    static var shared = SearchParameters()
    private init() {}
    
    func hasStartDate() -> Bool {
        return startDate != nil
    }
    
    func hasEndDate() -> Bool {
        return endDate != nil
    }
    
    mutating func didChange(_ dataType: DataType) {
        switch dataType {
        case .name(let value):
            name = value
        case .location(let value):
            location = value
        case .type(let value):
            type = value
        case .startDate(let date):
            startDate = date
        case .endDate(let date):
            endDate = date
        }
    }    
}

