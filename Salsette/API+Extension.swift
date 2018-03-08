//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

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
}
