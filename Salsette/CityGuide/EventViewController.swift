//
//  Salsette
//
//  Created by Marton Kerekes on 22/03/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var selectedIndex: IndexPath!
    var event: ContentEntityInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func actionButtonTapped(_ sender: Any) {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Open Facebook", style: .default, handler: { (openFBAction) in
            if let id = self.event.identifier, let url = URL(string: "https://www.facebook.com/events/\(id)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Open Google Maps", style: .default, handler: { (openGoogleMapsAction) in
            if let location = self.event.location?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
                let url = URL(string: "https://www.google.com/maps/place/\(location)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { (openOtherAction) in
            if let id = self.event.identifier, let shareContent = URL(string: "fb://events/\(id)") {
                let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: {})
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (openOtherAction) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
}
