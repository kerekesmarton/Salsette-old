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
    private var identifier: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.font = UIFont(name: ".SFUIText", size: 17)
        descriptionLabel.font = UIFont(name: ".SFUIText", size: 14)
    }
    var content: ContentEntityInterface? {
        didSet {
            guard let content = content else { return }
            let name = content.name
            
            heroID = "\(String(describing: name))"
            nameLabel.text = name
            descriptionLabel.text = useShortDescription ? content.shortDescription : content.description
            identifier = content.identifier
            loadImage(for: content.identifier)
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
}
