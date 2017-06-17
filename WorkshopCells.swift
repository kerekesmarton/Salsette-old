//  Created by Marton Kerekes on 17/06/2017.

import UIKit

class WorkshopCell: UICollectionViewCell {
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    func configure(workshop: Workshop) {
        nameLbl.text = workshop.name
        timeLbl.text = DateFormatters.timeFormatter.string(from: workshop.startTime)
        if workshop.isEmpty {
            self.nameLbl.backgroundColor = UIColor.lightGray
            self.timeLbl.backgroundColor = UIColor.lightGray
        } else {
            self.nameLbl.backgroundColor = UIColor.darkGray
            self.timeLbl.backgroundColor = UIColor.darkGray
        }
    }
}

class RoomCell: UICollectionReusableView {
    @IBOutlet var nameLbl: UILabel!
}
