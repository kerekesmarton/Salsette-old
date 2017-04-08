//
//  ContentConstants.swift
//  Salsette
//
//  Created by Marton Kerekes on 30/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

public protocol ContentEntityInterface {
    var image: UIImage? { get }
    var organiser: String { get }
    var name: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var location: String { get }
    var type: EventTypes { get }
}

public enum EventTypes: String {
    
    case salsa = "Salsa"
    case bachata = "Bachata"
    case kizomba = "Kizomba"
    case tango = "Tango"
    case any = "Any"
    
    static func count() -> Int {
        return 5
    }
    
    static func item(at index: Int) -> EventTypes {
        switch index {
        case 0: return EventTypes.salsa
        case 1: return EventTypes.bachata
        case 2: return EventTypes.kizomba
        case 3: return EventTypes.tango
        default: return EventTypes.any
        }
    }
    
    static func string(at index: Int) -> String {
        switch index {
        case 0: return EventTypes.salsa.rawValue
        case 1: return EventTypes.bachata.rawValue
        case 2: return EventTypes.kizomba.rawValue
        case 3: return EventTypes.tango.rawValue
        default: return EventTypes.any.rawValue
        }
    }
    
    public static func ==(lhs: EventTypes, rhs: EventTypes) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}