//
//  CreateEvent.swift
//  Salsette
//
//  Created by Marton Kerekes on 17/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class CreateEventViewController: UITableViewController, SelectFacebookEventProtocol {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDate: UILabel!

    var interactor: SelectFacebookEventInteractor?
    var items = [FacebookEventEntity]()
    var item: FacebookEventEntity?

    override func awakeFromNib() {
        super.awakeFromNib()
        interactor = SelectFacebookEventInteractor(with: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        eventName.text = item?.name
        eventLocation.text = item?.place
        var timeString: String?
        if let startTime = item?.startTime {
            timeString = DateFormatters.relativeDateFormatter.string(from: startTime)
        }
        if let endTime = item?.endTime {
            timeString?.append(" to " + DateFormatters.relativeDateFormatter.string(from: endTime))
        }
        eventDate.text = timeString ?? ""

        interactor?.getImage(for: item?.imageUrl, completion: { [weak self] (image) in
            self?.imageView?.image = image.fit(intoSize: CGSize(width: 93.5, height: 93.5))
            self?.imageView?.heroID = "asdf"
            self?.imageView?.heroModifiers = [.arc]

        })
        imageView?.heroID = item?.id
    }


    func show(error: Error) {

    }
}
