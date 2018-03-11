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
        descriptionLabel.font = UIFont.hoshiFont(ofSize: 14)
        imageView.image = nil
        imageView.layer.borderColor = UIColor.flatWhite.cgColor
        imageView.layer.borderWidth = 0.5
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
        }
    }
    
    private func configureDescriptionLabel() {
        guard let date = event?.startDate, let location = event?.location else {
            return
        }
        descriptionLabel.text = "\(date) \n@ \(location)"
    }
}
