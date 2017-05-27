//
//  Salsette
//
//  Created by Marton Kerekes on 04/05/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct Workshop {
    let name: String?
}

class WorkshopCell: UICollectionViewCell {
    @IBOutlet var nameLbl: UILabel!
}


class WorkshopsEditViewController: UICollectionViewController {

    var items = [Workshop](repeating: Workshop(name: "A"), count: 15)

    
    
}


extension WorkshopsEditViewController {
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkshopCell", for: indexPath)
        guard let workshopCell = cell as? WorkshopCell else {
            return cell
        }
        workshopCell.nameLbl.text = item.name
        return workshopCell
    }
}

class WorkshopsLayout: UICollectionViewLayout {
    
    struct DesiredSize {
        let width: CGFloat?
        let height: CGFloat?
    }
    var desiredSize: DesiredSize {
        get {
            return DesiredSize(width: collectionView?.frame.width, height: collectionView?.frame.height)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else { return UIScreen.main.bounds.size }
        let w = CGFloat(integerLiteral: cv.numberOfItems(inSection: 0)) * desiredSize.width!
        let h = CGFloat(cv.numberOfSections) * desiredSize.height
        return CGSize(width: w, height: h)
    }
}



