//  Copyright © 2017 Marton Kerekes. All rights reserved.

import Foundation

extension NSError {
    public convenience init(with message: String) {
        self.init(domain: "Client", code: 0, userInfo: [NSLocalizedDescriptionKey:message])
    }
}
