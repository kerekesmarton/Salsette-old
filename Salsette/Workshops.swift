//
//  Salsette
//
//  Created by Marton Kerekes on 16/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct Workshop {
    let title: String
    let location: String
    let organiser: String
}

class WorkshopsViewController: UICollectionViewController {
    
}

class WorkshopViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
}

class CollectionViewLayout: UICollectionViewFlowLayout {
    var idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    
    override func prepare() {
        self.scrollDirection = .vertical
        self.minimumLineSpacing = idiom == .pad ? 16 : 0
        self.minimumInteritemSpacing = idiom == .pad ? 16 : 0
        self.sectionInset = UIEdgeInsets(top: minimumLineSpacing, left: minimumLineSpacing, bottom: self.minimumLineSpacing, right: minimumLineSpacing)
        
        switch idiom {
        case .phone:
            guard let safeCollectionView = collectionView else { return }
            self.itemSize = CGSize(width: safeCollectionView.bounds.width, height: CGFloat(CollectionViewConstants.iphoneCellFixedHeight))
        case .pad:
            let cellSize = calculateDynamicCellSize(forCells: CollectionViewConstants.iPadNumberOfCellsPerRow, padding: minimumLineSpacing, margin: CollectionViewConstants.margin)
            
            self.itemSize = CGSize(width: cellSize, height: cellSize + CGFloat(CollectionViewConstants.labelPadding))
        default:
            super.prepare()
            return
        }
        super.prepare()
    }
    
    func calculateDynamicCellSize(forCells numberOfCellsPerRow: CGFloat, padding: CGFloat, margin: CGFloat) -> CGFloat {
        guard let width = collectionView?.bounds.width else {
            return 0
        }
        
        let totalMarginWidth = (numberOfCellsPerRow - 1) * padding
        return floor(((width - (2 * margin)) - totalMarginWidth) / numberOfCellsPerRow)
    }
}

enum CollectionViewConstants {
    static let margin: CGFloat = 16.0
    static let iPadNumberOfCellsPerRow: CGFloat = 5
    static let labelPadding: CGFloat = 56
    static let iphoneCellFixedHeight: CGFloat = 48
}
