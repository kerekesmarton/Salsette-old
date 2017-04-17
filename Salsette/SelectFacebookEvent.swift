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

private struct SelectFacebookEventFeatureLauncher {
    
    static func configure(viewController: SelectFacebookEventViewController) {
        viewController.interactor = SelectFacebookEventInteractor(with: viewController, manager: FacebookPermissions.shared, downloader: ImageDownloader.shared)
    }
}

class SelectFacebookEventViewController: UITableViewController {
    fileprivate static let cellId = "SelectFacebookEventCell"
    fileprivate var interactor: SelectFacebookEventInteractor?
    var items = [SelectFacebookEventEntity]() {
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
        interactor?.ready()
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
}

fileprivate class SelectFacebookEventInteractor {
    private weak var view: SelectFacebookEventViewController?
    private var facebookPermissions: FacebookPermissions?
    private var connection: FBSDKGraphRequestConnection?
    private var imageDownloader: ImageDownloader?
    init(with view: SelectFacebookEventViewController, manager: FacebookPermissions, downloader: ImageDownloader) {
        self.view = view
        self.facebookPermissions = manager
        self.imageDownloader = downloader
    }
    
    fileprivate func ready() {
        facebookPermissions?.askFor(permissions: ["user_events"], from: view!, completion: { [weak self] (result, error) in
            if let  error = error {
                print(error)
            }
            let request = FBSDKGraphRequest(graphPath: "me/events?type=created&since=now", parameters: ["fields":"name,place,start_time,end_time,cover,description,id"])
            self?.connection = request?.start(completionHandler: { [weak self] (connection, result, error) in
                guard let error = error else {
                    self?.updateView(with: result)
                    return
                }
                print(error)
            })
        })
    }
    
    fileprivate func cancel() {
        if let existingConnection = connection {
            existingConnection.cancel()
        }
    }

    fileprivate func getImage(for urlString: String?, completion:@escaping ((UIImage)->Void)) {
        imageDownloader?.downloadImage(for: urlString, completion: { (image) in
            completion(image)
        })
    }
    
    private func updateView(with results: Any?) {
        view?.items = parseEvents(from: results)
    }

    fileprivate func parseEvents(from results: Any?) -> [SelectFacebookEventEntity] {
        guard let parseableResults = results as? [String: Any],
            let events = parseableResults["data"] as? [[String: Any]] else {
                return []
        }
        return events.flatMap({ SelectFacebookEventEntity(with: $0)})
    }
}

class SelectFacebookEventEntity {
    var name: String?
    var place: String?
    var startTime: Date?
    var endTime: Date?
    var imageUrl: String?
    var id: String?
    
    convenience init(with dictionary:[String:Any]) {
        self.init()
        let dictionary = JSON(dictionary)
        name = dictionary["name"].string
        place = dictionary["place"]["name"].string
        id = dictionary["id"].string
        if let time = dictionary["start_time"].string {
            startTime = DateFormatters.dateTimeFormatter.date(from: time)
        }
        if let url = dictionary["cover"]["source"].string {
            self.imageUrl = url
        }
        if let time = dictionary["end_time"].string {
            self.endTime = DateFormatters.dateTimeFormatter.date(from: time)
        }
    }
}

class SelectFacebookEventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var imageUrl: String?
}
