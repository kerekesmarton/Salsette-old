//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(item: Element) -> Bool{
        if let index = index(of: item) {
            remove(at: index)
            return true
        }
        return false
    }
}
