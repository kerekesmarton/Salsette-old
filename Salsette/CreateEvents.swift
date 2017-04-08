//
//  CreateEvents.swift
//  Salsette
//
//  Created by Marton Kerekes on 01/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit

private struct CreateEventFeatureLauncher {
    
    static func configure(viewController: CreateEventViewController) {
        viewController.interactor = CreateEventInteractor(with: viewController, manager: FacebookPermissions.shared, downloader: ImageDownloader.shared)
    }
}

class CreateEventViewController: UITableViewController {
    fileprivate static let cellId = "CreateEventCell"
    fileprivate var interactor: CreateEventInteractor?
    var items = [CreateEventEntity]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CreateEventFeatureLauncher.configure(viewController: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateEventViewController.cellId) as! CreateEventCell
        cell.titleLabel.text = item.name
        guard let startTime = item.startTime, let endTime = item.endTime, let place = item.place else {
            return cell
        }
        cell.timeLabel.text = DateFormatters.relativeDateFormatter.string(from: startTime) + " to " + DateFormatters.relativeDateFormatter.string(from: endTime)
        cell.locationLabel.text = place
        cell.imageUrl = item.imageUrl
        interactor?.getImage(for: item.imageUrl, completion: { (image) in
            DispatchQueue.main.async {
                if cell.imageUrl == item.imageUrl {
                    cell.eventImage?.image = image.fit(intoSize: CGSize(width: 93.5, height: 93.5))
                }
            }
        })
        return cell
    }
}

fileprivate class CreateEventInteractor {
    private weak var view: CreateEventViewController?
    private var facebookPermissions: FacebookPermissions?
    private var connection: FBSDKGraphRequestConnection?
    private var imageDownloader: ImageDownloader?
    init(with view: CreateEventViewController, manager: FacebookPermissions, downloader: ImageDownloader) {
        self.view = view
        self.facebookPermissions = manager
        self.imageDownloader = downloader
    }
    
    fileprivate func ready() {
        facebookPermissions?.askFor(permissions: ["user_events"], from: view!, completion: { [weak self] (result, error) in
            if let  error = error {
                print(error)
            }
            let request = FBSDKGraphRequest(graphPath: "me/events?type=created", parameters: ["fields":"name,place,start_time,end_time,cover,description"])
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
        imageDownloader?.downloadImage(for: urlString, completion: completion)
    }
    
    private func updateView(with results: Any?) {
        view?.items = CreateEventEntity.parseEvents(from: results)
    }
}

class CreateEventEntity {
    var name: String?
    var place: String?
    var startTime: Date?
    var endTime: Date?
    var imageUrl: String?
    
    fileprivate class func parseEvents(from results: Any?) -> [CreateEventEntity] {
        guard let parseableResults = results as? [String: Any],
            let events = parseableResults["data"] as? [[String: Any]] else {
                return []
        }
        return events.flatMap({ CreateEventEntity(with: $0)})
    }
    
    convenience init(with dictionary:[String:Any]) {
        self.init()
        let dictionary = JSON(dictionary)
        name = dictionary["name"].string
        place = dictionary["place"]["name"].string
        if let time = dictionary["start_time"].string {
            startTime = DateFormatters.dateTimeFormatter.date(from: time)
        }
        if let url = dictionary["cover"]["souce"].string {
            self.imageUrl = url
        }
        if let time = dictionary["end_time"].string {
            self.endTime = DateFormatters.dateTimeFormatter.date(from: time)
        }
    }
}

class CreateEventCell: UITableViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var imageUrl: String?
}
