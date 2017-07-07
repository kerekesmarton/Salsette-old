//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

extension UICollectionViewFlowLayout {
    
    func calculateDynamicCellSize(forCells numberOfCellsPerRow: CGFloat, padding: CGFloat, margin: CGFloat) -> CGFloat {
        
        guard let cv = collectionView, cv.bounds.width > CGFloat(0)  else {
            return 0
        }
        let totalMarginWidth = (numberOfCellsPerRow - 1) * padding
        return floor(((cv.bounds.width - (2 * margin)) - totalMarginWidth) / numberOfCellsPerRow)
    }
}
