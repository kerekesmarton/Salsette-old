//
//  SelectFacebookEvents.swift
//  Salsette
//
//  Created by Marton Kerekes on 01/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit

struct SelectFacebookEventFeatureLauncher {
    
    static func configure(viewController: SelectFacebookEventViewController) {
        viewController.interactor = SelectFacebookEventInteractor(with: viewController, fbService: FacebookService.shared, downloader: ImageDownloader.shared)
    }
}

class SelectFacebookEventViewController: UITableViewController, SelectFacebookEventProtocol {
    fileprivate static let cellId = "SelectFacebookEventCell"
    internal var interactor: SelectFacebookEventInteractor?
    var items = [FacebookEventEntity]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SelectFacebookEventFeatureLauncher.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose an event to start with.."
        interactor?.prepare(from: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.cancel()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectFacebookEventViewController.cellId) as! SelectFacebookEventCell
        cell.titleLabel.text = item.name

        var timeString: String?
        if let startTime = item.startTime {
            timeString = DateFormatters.relativeDateFormatter.string(from: startTime)
        }
        if let endTime = item.endTime {
            timeString?.append(" to " + DateFormatters.relativeDateFormatter.string(from: endTime))
        }
        cell.timeLabel.text = timeString ?? ""
        cell.locationLabel.text = item.place ?? ""
        cell.imageUrl = item.imageUrl
        interactor?.getImage(for: item.imageUrl, completion: { (image) in
            if cell.imageUrl == item.imageUrl {
                cell.eventImage?.image = image.fit(intoSize: CGSize(width: 93.5, height: 93.5))
            }
        })
        return cell
    }

    func show(error: Error) {
        self.present(UIAlertController.errorAlert(with: error), animated: false, completion: nil)
    }
}

class SelectFacebookEventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var imageUrl: String?
}
