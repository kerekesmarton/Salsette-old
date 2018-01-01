//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

public protocol SearchableEntity {
    var image: UIImage? { get }
    var imageUrl: String? { get }
    var organiser: String? { get }
    var name: String? { get }
    var startDate: Date? { get }
    var endDate: Date? { get }
    var place: String? { get }
    var location: String? { get }
    var shortDescription: String? { get }
    var longDescription: String? { get }
    var identifier: String? { get }    
}

extension SearchableEntity {
    var shortDescription: String {
        get {
            return name ?? ""
        }
    }
    var description: String {
        get {
            return ""
        }
    }
}

extension Dance {
    
    static let allDanceTypes = [salsa, bachata, kizomba, tango, dance]
    
    static func item(at index: Int) -> Dance {
        switch index {
        case 0: return Dance.salsa
        case 1: return Dance.bachata
        case 2: return Dance.kizomba
        case 3: return Dance.tango
        default: return Dance.dance
        }
    }
    
    static func string(at index: Int) -> String {
        switch index {
        case 0: return Dance.salsa.rawValue
        case 1: return Dance.bachata.rawValue
        case 2: return Dance.kizomba.rawValue
        case 3: return Dance.tango.rawValue
        default: return Dance.dance.rawValue
        }
    }
    
    public static func ==(lhs: Dance, rhs: Dance) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
