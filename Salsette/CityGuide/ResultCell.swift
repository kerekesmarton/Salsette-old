//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit
import ChameleonFramework

class ResultCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var useShortDescription: Bool = true
    private var identifier: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.font = UIFont.hoshiFont(ofSize: 17)
        nameLabel.textColor = UIColor.flatWhite
        descriptionLabel.font = UIFont.hoshiFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.flatWhite
        imageView.image = nil
    }
    
    var event: SearchResult? {
        didSet {
            guard let event = event else { return }
            
            nameLabel.text = event.name
            identifier = event.identifier
            loadImage(for: event.identifier)
            configureDescriptionLabel()
        }
    }
    
    private func loadImage(for identifier: String?) {
        if let image = event?.image {
            imageView.image = image
        } else if let url = event?.imageUrl {
            ImageDownloader.shared.downloadImage(for: url, completion: { (image) in
                if self.identifier == identifier {
                    self.imageView.image = image
                }
            })
        } else {
            nameLabel.textColor = UIColor.flatBlack
            descriptionLabel.textColor = UIColor.flatBlack
        }
    }
    
    private func configureDescriptionLabel() {
        guard let date = event?.startDate, let location = event?.location else {
            return
        }
        descriptionLabel.text = "\(date) \n@ \(location)"
    }
}
