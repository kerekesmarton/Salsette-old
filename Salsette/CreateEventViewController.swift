//
//  CreateEvent.swift
//  Salsette
//
//  Created by Marton Kerekes on 17/04/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

class CreateEventViewController: UITableViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var classesLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!

    var item: FacebookEventEntity?
    var createdItem: ContentEntityInterface?
    private var imageDownloader: ImageDownloader?

    var selectedEventType: EventTypes? {
        didSet {
            typeTextField.text = selectedEventType?.rawValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageDownloader = ImageDownloader.shared
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        eventName.text = item?.name
        eventLocation.text = item?.location
        var timeString: String?
        if let startTime = item?.startDate {
            timeString = DateFormatters.relativeDateFormatter.string(from: startTime)
        }
        if let endTime = item?.endDate {
            timeString?.append(" to " + DateFormatters.relativeDateFormatter.string(from: endTime))
        }
        eventDate.text = timeString ?? ""

        imageDownloader?.downloadImage(for: item?.imageUrl, completion: { [weak self] (image) in
            self?.imageView?.image = image.fit(intoSize: CGSize(width: 93.5, height: 93.5))
        })

        selectedEventType = item?.type

        let picker = UIPickerView()
        typeTextField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        typeTextField.delegate = self
    }
}

extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventTypes.allEventTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventTypes.string(at: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEventType = EventTypes.item(at: row)
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
