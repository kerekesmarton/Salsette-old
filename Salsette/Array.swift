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
    
    @discardableResult mutating func remove(with predicate: (Element) throws -> Bool) -> Bool {
        do {
            if let index = try index(where: predicate){
                remove(at: index)
                return true
            }
            return false
        } catch {
            return false
        }        
    }
}
