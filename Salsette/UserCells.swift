//
//  UserEventCells.swift
//  Salsette
//
//  Created by Marton Kerekes on 21/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Hero

enum UserCellIdentifiers {
    static let imageIdentifier = "UserImageCell"
    static let nameIdentifier = "UserNameCell"
    static let eventIdentifier = "UserEventsCreationCell"

    static let allIdentifiers = [imageIdentifier, nameIdentifier, eventIdentifier]
}

class UserImageCell: UITableViewCell {
    @IBOutlet var profilePictureView: FBSDKProfilePictureView?
}

class UserNameCell: UITableViewCell {
    @IBOutlet var userNameLabel: UILabel?
}

class UserEventsCreationCell: UITableViewCell, SelectFacebookEventProtocol {
    @IBOutlet var eventCollectionView: UICollectionView?
    var interactor: SelectFacebookEventInteractor?
    var items: [FacebookEventEntity] = [] {
        didSet {
            eventCollectionView?.delegate = self
            eventCollectionView?.dataSource = self
            eventCollectionView?.reloadData()
        }
    }
    var selectionBlock: ((FacebookEventEntity) -> Void)?

    func show(error: Error) {
        
    }
    
    func configure(with viewController: UIViewController) {
        interactor = SelectFacebookEventInteractor(with: self, fbService: FacebookService.shared, downloader: ImageDownloader.shared)
        interactor?.prepare(from: viewController)
    }

    //offline testing
//    func configure(with viewController: UIViewController) {
//        interactor = SelectFacebookEventInteractor(with: self, fbService: FacebookService.shared, downloader: ImageDownloader.shared)
//        items = dummyEvents()
//    }
    
    func dummyEvents() -> [FacebookEventEntity] {
        var entities = [FacebookEventEntity]()
        for _ in 0...3 {
            let entity = FacebookEventEntity(with: "asdf")
            entity.name = "salsa party"
            entity.startDate = Date().addingTimeInterval(36000)
            entity.location = "Milan"
            entities.append(entity)
        }

        return entities
    }
}

extension UserEventsCreationCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserEventCell", for: indexPath)
        guard let userEventCell = cell as? UserEventCollectionViewCell else {
            return cell
        }
        let item = items[indexPath.row]
        userEventCell.item = item
        interactor?.getImage(for: item.imageUrl, completion: { (image) in
            if userEventCell.imageUrl == item.imageUrl {
                userEventCell.eventImage?.heroID = item.id
                userEventCell.eventImage?.image = image.fit(intoSize: CGSize(width: 93.5, height: 93.5))
            }
        })
        return userEventCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard let block = selectionBlock else {
            return
        }
        
        block(item)
    }
}

class UserEventCollectionViewCell: UICollectionViewCell {    
    @IBOutlet var eventImage: UIImageView?
    @IBOutlet var eventName: UILabel?
    @IBOutlet var eventDetails: UILabel?
    var imageUrl: String?
    var item: FacebookEventEntity? {
        didSet {
            eventName?.text = item?.name

            var timeString: String?
            if let startTime = item?.startDate {
                timeString = DateFormatters.relativeDateFormatter.string(from: startTime)
            }
            if let endTime = item?.endDate {
                timeString?.append(" to " + DateFormatters.relativeDateFormatter.string(from: endTime))
            }
            eventDetails?.text = timeString ?? ""
            imageUrl = item?.imageUrl
        }
    }
}
