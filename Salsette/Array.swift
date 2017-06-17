//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    @discardableResult mutating func remove(item: Element) -> Bool{
        if let index = index(of: item) {
            remove(at: index)
            return true
        }
        return false
    }
}
