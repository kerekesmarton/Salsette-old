//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  var useShortDescription: Bool = true

  var content: ContentEntityInterface? {
    didSet {
      guard let city = content else { return }
      let name = city.name

      heroID = "\(String(describing: name))"

      nameLabel.text = name
      imageView.image = city.image
      descriptionLabel.text = useShortDescription ? city.shortDescription : city.description
    }
  }
}
