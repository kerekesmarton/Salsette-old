//
//  ContentConstants.swift
//  Salsette
//
//  Created by Marton Kerekes on 30/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation

public enum EventTypes: String {
    case danceclass = "Dance class"
    case party = "Party"
    
    static func count() -> Int {
        return 2
    }
    
    static func item(at index: Int) -> String? {
        switch index {
        case 0: return EventTypes.danceclass.rawValue
        case 1: return EventTypes.party.rawValue
        default: return nil
        }
    }
}
