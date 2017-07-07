//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var useShortDescription: Bool = true
    private var identifier: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.font = UIFont.hoshiFont(ofSize: 17)
        descriptionLabel.font = UIFont.hoshiFont(ofSize: 14)
        imageView.image = nil
        imageView.layer.borderColor = UIColor.flatWhite.cgColor
        imageView.layer.borderWidth = 0.5
    }
    var content: ContentEntityInterface? {
        didSet {
            guard let content = content else { return }
            
            heroID = content.name
            nameLabel.text = content.name
            identifier = content.identifier
            loadImage(for: content.identifier)
            configureDescriptionLabel()
        }
    }
    
    private func loadImage(for identifier: String?) {
        if let image = content?.image {
            imageView.image = image
        } else if let url = content?.imageUrl {
            ImageDownloader.shared.downloadImage(for: url, completion: { (image) in
                if self.identifier == identifier {
                    self.imageView.image = image
                }
            })
        }
    }
    
    private func configureDescriptionLabel() {
        if let date = content?.startDate, let location = content?.location {
            let dateString = DateFormatters.relativeDateFormatter.string(from: date)
            descriptionLabel.text = "\(dateString) \n@ \(location)"
        } else {
            descriptionLabel.text = useShortDescription ? content?.shortDescription : content?.longDescription
        }
    }
}
