//  Copyright © 2017 Marton Kerekes. All rights reserved.

import UIKit
import FBSDKCoreKit
import TextFieldEffects
import DZNEmptyDataSet

enum UserCellIdentifiers {
    static let imageIdentifier = "UserCell"
    static let savedEventIdentifier = "SavedEventsCell"
    static let createdEventIdentifier = "CreatedEventsCell"
    static let allIdentifiers = [imageIdentifier, savedEventIdentifier, createdEventIdentifier]
}

class UserCell: UITableViewCell {
    @IBOutlet var profilePictureView: UIImageView?
    @IBOutlet var userNameLabel: UILabel?
    @IBOutlet var favoriteSong: HoshiTextField!
    @IBOutlet var aboutMe: HoshiTextField!
}

class EventsCell: UITableViewCell, SelectFacebookEventProtocol {
    @IBOutlet var eventCollectionView: UICollectionView?
    var interactor: SelectFacebookEventInteractor = SelectFacebookEventInteractor(fbService: FacebookService.shared, downloader: ImageDownloader.shared)
    var items: [FacebookEventEntity]! = [] {
        didSet {
            eventCollectionView?.delegate = self
            eventCollectionView?.dataSource = self
            eventCollectionView?.reloadData()
            guard items.count == 0 else { return }
            errorMessage = "No events found"            
        }
    }
    var selectionBlock: ((FacebookEventEntity) -> Void)?
    func show(error: Error) {
        errorMessage = error.localizedDescription
        items = []
    }
    fileprivate var errorMessage: String?
    
    //online
    func configureForSavedEvents() {
        interactor.prepareForSavedEvents(with: self)
    }

    func configureForCreatedEvents() {
        interactor.prepareForCreatedEvents(with: self)
    }

    //offline testing
//    func configureForSavedEvents() {
//        items = DummyDataSource().dummyEvents
//    }
//
//    func configureForCreatedEvents() {
//        items = DummyDataSource().dummyEvents
//    }
}

extension EventsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath)
        guard let userEventCell = cell as? EventCollectionViewCell else {
            return cell
        }
        let item = items[indexPath.row]
        userEventCell.item = item
        interactor.getImage(for: item.imageUrl, completion: { (image) in
            if userEventCell.imageUrl == item.imageUrl {
                userEventCell.eventImage?.image = image
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

extension EventsCell: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let msg = errorMessage else { return NSAttributedString() }
        return NSAttributedString(string: msg)
    }
}

class EventCollectionViewCell: UICollectionViewCell {    
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
