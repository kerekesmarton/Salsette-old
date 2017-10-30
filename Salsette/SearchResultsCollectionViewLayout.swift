//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit

class SearchResultsCollectionViewLayout: UICollectionViewFlowLayout {

    private enum constants {
        static let margin: CGFloat = 8.0
        static let iPadNumberOfCellsPerRow: CGFloat = 3
        static let labelPadding: CGFloat = 56
        static let iphoneCellFixedHeight: CGFloat = 260
    }

    fileprivate var idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    fileprivate var orientation: UIDeviceOrientation?
    
    override func prepare() {
        orientation = UIDevice.current.orientation
        scrollDirection = .vertical
        minimumLineSpacing = idiom == .pad ? 16 : 0
        minimumInteritemSpacing = idiom == .pad ? 16 : 0
        sectionInset = UIEdgeInsets(top: minimumLineSpacing, left: minimumLineSpacing, bottom: minimumLineSpacing, right: minimumLineSpacing)
        
        switch idiom {
        case .phone:
            guard let cv = collectionView else { return }
            itemSize = CGSize(width: cv.bounds.width - (2 * constants.margin), height: CGFloat(constants.iphoneCellFixedHeight))
        case .pad:
            let cellSize = calculateDynamicCellSize(forCells: constants.iPadNumberOfCellsPerRow, padding: minimumLineSpacing, margin: constants.margin)
            itemSize = CGSize(width: cellSize, height: cellSize + CGFloat(constants.labelPadding))
            
        default:
            super.prepare()
            return
        }
        minimumLineSpacing = constants.margin
        minimumInteritemSpacing = constants.margin
        super.prepare()
    }
}
