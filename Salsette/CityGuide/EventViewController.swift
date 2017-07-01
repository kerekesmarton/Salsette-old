//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController {
    var selectedIndex: IndexPath!
    var event: ContentEntityInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.customizeTransparentNavigationBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EventViewController.cancel))
    }
    
    @objc private func cancel() {
        dismiss(animated: true)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.heroID = event.name
        ImageDownloader.shared.downloadImage(for: event.imageUrl) { (image) in
            self.imageView.image = image
        }
        nameLabel.text = event.name
        hostLabel.text = event.place
        if let time = event.startDate {
            startDate.text = DateFormatters.relativeDateFormatter.string(from: time)
        }
        if let time = event.endDate {
            endDate.text = DateFormatters.relativeDateFormatter.string(from: time)
        } else {
            endDate.text = ""
        }
        placeLabel.text = event.place
        locationLabel.text = event.location
        descriptionLabel.text = event.longDescription
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 4:
            guard let desc = event.longDescription else { return 0 }
            return desc.height(withConstrainedWidth: tableView.frame.width - (tableView.contentInset.left + tableView.contentInset.right), font: UIFont.systemFont(ofSize: 18))
        default:
            return 60
        }
    }

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
}
