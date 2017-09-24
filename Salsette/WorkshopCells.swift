//  Created by Marton Kerekes on 17/06/2017.

import UIKit

class WorkshopCell: UICollectionViewCell {
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    func configure(workshop: GraphWorkshop) {
        nameLbl.text = workshop.name
        timeLbl.text = DateFormatters.timeFormatter.string(from: workshop.startTime)
        if workshop.isEmpty {
            nameLbl.backgroundColor = UIColor.flatWhite
            timeLbl.backgroundColor = UIColor.flatWhite
        } else {
            nameLbl.backgroundColor = UIColor.flatGray
            timeLbl.backgroundColor = UIColor.flatGray
        }
    }
}

class RoomCell: UICollectionReusableView {
    @IBOutlet var nameLbl: UILabel!
    
    override func prepareForReuse() {
        nameLbl.backgroundColor = UIColor.flatGrayDark
    }
}
